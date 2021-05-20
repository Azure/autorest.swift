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
        "output-folder",
        "clear-output-folder",
        "project-folder",
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
        "package-version",
        "generate-as-internal"
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

    /// The desired output folder for code
    var outputFolder: String? {
        return rawArgs["output-folder"]
    }

    /// Whether the output folder should be cleared before generating code.
    var clearOutputFolder: Bool? {
        return Bool(rawArgs["clear-output-folder"] ?? "False")
    }

    /// The root of the project if the code will be generated in a subfolder
    var projectFolder: String? {
        return rawArgs["project-folder"]
    }

    /// Whether to include a credential object in the generated code
    var addCredential: Bool? {
        return Bool(rawArgs["add-credential"] ?? "False")
    }

    /// The scopes to use for generated credentials
    var credentialScopes: [String]? {
        return split(string: rawArgs["credential-scopes"])
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

    /// Transforms for model types
    var generateAsInternal: ModelMap {
        return ModelMap(with: rawArgs["generate-as-internal"])
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
        if let session = sessionId, let channelClient = client {
            collectRpcValues(with: channelClient, sessionId: session) {
                completion()
            }
        } else {
            completion()
        }
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

    private func collectRpcValues(with client: ChannelClient, sessionId: String, completion: @escaping () -> Void) {
        let futures = supportedKeys
            .map { client.call(method: "GetValue", params: .list([.string(sessionId), .string($0)])) }
        let future = EventLoopFuture.whenAllSucceed(futures, on: client.context!.eventLoop)
        future.whenSuccess { results in
            for (index, rpcResult) in results.enumerated() {
                if case let RPCResult.success(response) = rpcResult {
                    let key = self.supportedKeys[index]
                    self.rawArgs[key] = response.asString
                }
            }
            completion()
        }
        future.whenFailure { error in
            SharedLogger.fail("GetValue failed: \(error)")
        }
    }

    func encode(to encoder: Encoder) throws {
        try rawArgs.encode(to: encoder)
    }
}

internal struct ModelMap {
    internal var map: [String: String]
    internal var reverseMap: [String: String]

    init(with string: String?) {
        self.map = [String: String]()
        self.reverseMap = [String: String]()
        guard let splitVals = split(string: string) else { return }
        for item in splitVals {
            let comps = item.split(separator: "=", maxSplits: 1).map { String($0) }
            if comps.count != 2 {
                SharedLogger.fail("Incorrect usage: --generate-as-internal NAME=ALIAS ...")
            }
            map[comps[0]] = comps[1]
            reverseMap[comps[1]] = comps[0]
        }
    }

    /// Returns internal for models which are aliased. Otherwise, public.
    internal func visibility(for name: String) -> String {
        // if the name is in the map or reverse map, the visibility should be internal
        let test = map[name] ?? reverseMap[name]
        return test != nil ? "internal" : "public"
    }

    /// Returns the alias for a model or the original model name if no alias present
    internal func aliasOrName(for name: String) -> String {
        if let alias = map[name] {
            return alias
        } else {
            return name
        }
    }

    /// Returns the alias for a given name or nil if no alias is present
    internal func alias(for name: String) -> String? {
        return map[name]
    }

    /// Returns the name for a given alias or nil if no name is present
    internal func name(for alias: String) -> String? {
        return reverseMap[alias]
    }
}

private func split(string val: String?) -> [String]? {
    guard let value = val else { return nil }
    return value.components(separatedBy: .whitespacesAndNewlines).filter { $0.count > 0 }
}
