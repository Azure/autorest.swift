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
    // MARK: Properties

    let inputUrl: URL

    let destinationRootUrl: URL

    lazy var logger = Logger(withName: "Autorest.Swift")

    // MARK: Initializers

    init(withInputUrl input: URL, destinationUrl dest: URL) {
        self.inputUrl = input
        // TODO: Make this configurable
        self.destinationRootUrl = dest.appendingPathComponent("generated").appendingPathComponent("sdk")
        ensureExists(folder: destinationRootUrl)
    }

    // MARK: Methods

    func run() throws {
        let model = try loadModel()

        // Determine Swift names for all model objects
        let namer = SwiftNamer(withModel: model)
        try namer.process()

        // Generate Swift code files
        let generator = SwiftGenerator(withModel: model)
        try generator.generate()
    }

    /// Decodes the YAML code model file into Swift objects and evaluates model consistency
    private func loadModel() throws -> CodeModel {
        // decode YAML to model
        let decoder = YAMLDecoder()
        var yamlString = try String(contentsOf: inputUrl)
        // TODO: Remove when issue (https://github.com/Azure/autorest.swift/issues/47) is fixed.
        // Replaces empty string with a single space.
        yamlString = yamlString.replacingOccurrences(of: ": ''", with: ": ' '")

        let model = try decoder.decode(
            CodeModel.self,
            from: yamlString,
            userInfo: [AnyCodable.extensionStringDecodedKey: StringDecodeKeys()]
        )

        check(model: model, against: yamlString)

        return model
    }

    /// Check model for consistency and save debugging files if inconsistent
    private func check(model: CodeModel, against yamlString: String) {
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
                logger.log(error.localizedDescription, level: .error)
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
            do {
                try beforeJsonString?.write(to: beforeJsonUrl, atomically: true, encoding: .utf8)
                try afterJsonString?.write(to: afterJsonUrl, atomically: true, encoding: .utf8)
                logger
                    .log(
                        "Discrepancies found in round-tripped code model. Run a diff on 'before.json' and 'after.json' to troubleshoot."
                    )
            } catch {
                logger.log(
                    "Discrepancies found in round-tripped code model. Error saving files: \(error.localizedDescription)",
                    level: .error
                )
            }
        } else if beforeJsonString == nil || afterJsonString == nil {
            logger.log("Errors found trying to decode models. Please check your Swagger file.", level: .error)
        } else {
            logger.log("Model file check: OK", level: .info)
        }
    }

    private func ensureExists(folder: URL) {
        let fileManager = FileManager.default

        if let existing = try? folder.resourceValues(forKeys: [.isDirectoryKey]) {
            if !existing.isDirectory! {
                let err = "Path exists but is not a folder!"
                logger.log(err, level: .error)
                fatalError(err)
            }
        } else {
            // Path does not exist so let us create it
            do {
                try fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
