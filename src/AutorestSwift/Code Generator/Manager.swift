// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation
import Yams

struct StringDecodeKeys: ExtensionStringDecodeKeys {
    var stringDecodedKeys = ["clientMessageId", "shareHistoryTime", "id", "messageId", "createdAt", "version"]
}

/// Handles the configuration and orchestrations of the code generation process
class Manager {
    internal enum InvocationMode {
        case autorest
        case commandLine
    }

    // MARK: Properties

    let inputString: String

    let destinationRootUrl: URL
    var packageUrl: URL?

    let mode: InvocationMode

    // MARK: Initializers

    /// Initialize with an input file URL (i.e. running locally).
    init(withInputUrl input: URL, destinationUrl dest: URL) throws {
        self.mode = .commandLine

        let yamlString = try String(contentsOf: input)
        self.inputString = Manager.sanitize(yaml: yamlString)
        self.packageUrl = nil

        // TODO: Make this configurable
        self.destinationRootUrl = dest.appendingPathComponent("generated").appendingPathComponent("sdk")
        do {
            try destinationRootUrl.ensureExists()
        } catch {
            SharedLogger.fail("\(error)")
        }
    }

    /// Initialize with a raw YAML string (i.e. the way it is received from Autorest).
    init(withString string: String) {
        self.mode = .autorest
        self.inputString = Manager.sanitize(yaml: string)
        // for autorest mode, create a temp directory using a random Guid as the directory name
        self.destinationRootUrl = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(UUID().uuidString)
        self.packageUrl = nil
    }

    // MARK: Methods

    private static func sanitize(yaml: String) -> String {
        // TODO: Remove when issue (https://github.com/Azure/autorest.swift/issues/47) is fixed.
        // Replaces empty string with a single space.
        return yaml.replacingOccurrences(of: ": ''", with: ": ' '")
    }

    func run() throws {
        let model = try loadModel()
        _ = check(model: model, against: inputString)
        saveCodeModel()

        // Create folder structure
        let packageName = model.packageName
        let packageUrl = destinationRootUrl.appendingPathComponent(packageName)
        try packageUrl.ensureExists()

        self.packageUrl = packageUrl

        // Generate Swift code files
        SharedLogger.info("Generating code at: \(packageUrl.path)")
        let generator = SwiftGenerator(withModel: model, atBaseUrl: packageUrl)
        try generator.generate()

        // Run SwiftLint and SwiftFormat on generated files
        formatCode(atBaseUrl: packageUrl)
    }

    /// Decodes the YAML code model file into Swift objects and evaluates model consistency
    func loadModel() throws -> CodeModel {
        // decode YAML to model
        let decoder = YAMLDecoder()
        let model = try decoder.decode(
            CodeModel.self,
            from: inputString,
            userInfo: [AnyCodable.extensionStringDecodedKey: StringDecodeKeys()]
        )
        return model
    }

    /// Check model for consistency and save debugging files if inconsistent
    private func check(model: CodeModel, against yamlString: String) -> Bool {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

        var beforeJsonString: String?
        var afterJsonString: String?

        // get JSON representation of YAML
        if let beforeJson = try? Yams.load(yaml: yamlString) {
            do {
                let beforeJsonData = try JSONSerialization.data(
                    withJSONObject: beforeJson,
                    options: [.sortedKeys, .prettyPrinted]
                )
                beforeJsonString = String(data: beforeJsonData, encoding: .utf8)
            } catch {
                SharedLogger.fail("\(error)")
            }
        }

        // convert model to JSON
        if let afterJsonData = try? encoder.encode(model) {
            afterJsonString = String(data: afterJsonData, encoding: .utf8)
        }

        // If JSON strings don't match, there must be a problem in the modeling.
        // Dump both files so they can be diffed.
        if beforeJsonString != afterJsonString {
            let beforeJsonUrl = destinationRootUrl.appendingPathComponent("before.json")
            let afterJsonUrl = destinationRootUrl.appendingPathComponent("after.json")
            SharedLogger.debug("before.json url=\(beforeJsonUrl)")
            SharedLogger.debug("after.json url=\(afterJsonUrl)")
            do {
                try beforeJsonString?.write(to: beforeJsonUrl, atomically: true, encoding: .utf8)
                try afterJsonString?.write(to: afterJsonUrl, atomically: true, encoding: .utf8)
                SharedLogger
                    .warn(
                        "Discrepancies found in round-tripped code model. Run a diff on 'before.json' and 'after.json' to troubleshoot."
                    )
            } catch {
                SharedLogger.warn(
                    "Discrepancies found in round-tripped code model. Error saving files: \(error)"
                )
            }
        } else if beforeJsonString == nil || afterJsonString == nil {
            SharedLogger.fail("Errors found trying to decode models. Please check your Swagger file.")
        } else {
            SharedLogger.info("Model file check: OK")
        }
        return (beforeJsonString == afterJsonString)
    }

    private func formatCode(atBaseUrl baseUrl: URL) {
        runTool(with: "swiftformat", configFilename: ".swiftformat", arguments: ["--quiet", baseUrl.path])
        runTool(
            with: "swiftlint",
            configFilename: ".swiftlint.yml",
            arguments: ["autocorrect", "--quiet", baseUrl.path]
        )
    }

    private func runTool(with tool: String, configFilename: String, arguments: [String]) {
        var allArguments: [String] = []

        guard let toolPath = Bundle.main.path(forResource: tool, ofType: nil) else {
            SharedLogger.warn("Can't find path for tool \(tool) in path \(Bundle.main.bundlePath)")
            return
        }
        guard let configPath = Bundle.main.path(forResource: "", ofType: configFilename) else {
            SharedLogger
                .warn(
                    "Can't find config file for tool \(tool) with config \(configFilename) in path \(Bundle.main.bundlePath)."
                )
            return
        }

        allArguments.append("--config")
        allArguments.append(configPath)

        allArguments.append(contentsOf: arguments)

        do {
            let outputPipe = Pipe()
            let errorPipe = Pipe()

            let task = Process()
            task.standardOutput = outputPipe
            task.standardError = errorPipe
            task.executableURL = URL(fileURLWithPath: toolPath)
            task.arguments = allArguments
            try task.run()
            task.waitUntilExit()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            SharedLogger.debug("Stdout from \(tool) \(String(decoding: outputData, as: UTF8.self))")
            SharedLogger.debug("Stderr from \(tool) \(String(decoding: errorData, as: UTF8.self))")
        } catch {
            SharedLogger.fail("Fail to run tool \(tool).")
        }
    }

    func saveCodeModel() {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to locate Documents directory.")
        }
        let dest = documentsUrl.appendingPathComponent("code-model-v4.yaml")
        let finalString = inputString.replacingOccurrences(of: "' '", with: "''")
        try? finalString.write(to: dest, atomically: true, encoding: .utf8)
    }
}
