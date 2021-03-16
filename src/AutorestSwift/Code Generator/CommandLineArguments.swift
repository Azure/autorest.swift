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
import NIO

class CommandLineArguments: Encodable {
    private var rawArgs: [String: String]

    /// Keys which are supported by Autorest.Swift
    private let supportedKeys: [String] = [
        "input-filename",
        "output-directory",
        "clear-output-folder",
        "project-directory",
        "add-credential",
        "credential-scopes",
        "license-header",
        "namespace",
        "tag",
        "head-as-boolean",
        "title",
        "description",
        "client-side-validation",
        "package-name",
        "package-version"
    ]

    /// Keys which are explicitly unsupported and should throw and error if supplied
    private let unsupportedKeys: [String] = [
        "azure-arm",
        "trace"
    ]

    // MARK: Computed properties

    /// The input swagger filename
    var inputFilename: String? {
        return rawArgs["input-filename"]
    }

    /// The desired output directory for code
    var outputDirectory: String? {
        return rawArgs["output-directory"]
    }

    /// Whether the output folder should be cleared before generating code.
    var clearOutputFolder: Bool? {
        return Bool(rawArgs["clear-output-folder"] ?? "False")
    }

    /// The root of the project if the code will be generated in a subfolder
    var projectDirectory: String? {
        return rawArgs["project-directory"]
    }

    /// Whether to include a credential object in the generated code
    var addCredential: Bool? {
        return Bool(rawArgs["add-credential"] ?? "False")
    }

    /// The scopes to use for generated credentials
    var credentialScopes: [String]? {
        return rawArgs["credential-scopes"]?.components(separatedBy: " ")
    }

    /// Which license header to use for generated files.
    var licenseHeader: String? {
        return rawArgs["license-header"]
    }

    /// The generated package namespace
    var namespace: String? {
        return rawArgs["namespace"]
    }

    /// The tag used to generated the package
    var tag: String? {
        return rawArgs["tag"]
    }

    /// Treat HEAD requests a boolean True value
    var headAsBoolean: Bool? {
        return Bool(rawArgs["head-as-boolean"] ?? "False")
    }

    /// Used to rename the base client in lieu of the Swagger title
    var title: String? {
        return rawArgs["title"]
    }

    /// Used in lieu of the root description field from Swagger
    var description: String? {
        return rawArgs["description"]
    }

    /// Generated code with client-side validation, where specified in Swagger
    var clientSideValidation: Bool? {
        return Bool(rawArgs["client-side-validation"] ?? "False")
    }

    /// The package name to use for generated code
    var packageName: String? {
        return rawArgs["package-name"]
    }

    /// The package version to use for generated code
    var packageVersion: String? {
        return rawArgs["package-version"]
    }

    // MARK: Initializers

    init(client: ChannelClient?, sessionId: String?, completion: @escaping () -> Void) {
        self.rawArgs = [String: String]()

        // Load arguments from direct command line (run standalone)
        for item in CommandLine.arguments.dropFirst() {
            let key = parseKey(from: item)
            guard unsupportedKeys.contains(key) == false else {
                SharedLogger.fail("Autorest.Swift does not support --\(key)")
            }
            if supportedKeys.contains(key) == false {
                SharedLogger.warn("Autorest.Swift does not recognize --\(key)")
            }
            let value = parseValue(from: item)
            rawArgs[key] = value
        }

        // Load arguments from RPC, if available
        if let session = sessionId, let context = client?.context, let channelClient = client {
            do {
                let callResults: [RPCResult] = try context.eventLoop.flatSubmit {
                    let futures = self.supportedKeys
                        .map { channelClient.call(method: "GetValue", params: .list([.string(session), .string($0)])) }
                    return EventLoopFuture.whenAllSucceed(futures, on: context.eventLoop)
                }.wait()
                for case let RPCResult.success(resonse) in callResults {
                    SharedLogger.info(resonse.asString)
                }
            } catch {
                SharedLogger.fail("Error retrieving values: \(error)")
            }
        }
        completion()
    }

    /// Returns the argument key without the `--` prefix.
    private func parseKey(from item: String) -> String {
        guard let key = item.split(separator: "=", maxSplits: 1).map({ String($0) }).first else {
            SharedLogger.fail("Item \(item) contained no key.")
        }
        guard key.hasPrefix("--") else {
            SharedLogger.fail("Item \(key) expected to start with -- prefix.")
        }
        return String(key.dropFirst(2))
    }

    private func parseValue(from item: String) -> String {
        let values = Array(item.split(separator: "=", maxSplits: 1).map { String($0) }.dropFirst())
        switch values.count {
        case 0:
            // indicates flag
            return "True"
        case 1:
            return values[0]
        default:
            SharedLogger.fail("Error in item \(item). Expected at most 1 value. Found \(values.count)")
        }
    }

    func encode(to encoder: Encoder) throws {
        try rawArgs.encode(to: encoder)
    }
}
