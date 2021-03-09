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

import Dispatch
import Foundation
import NIO

class ManagerConfig {
    private var client: ChannelClient?
    private var sessionId: String?

    var inputFilename: String?
    var outputDirectory: String?
    var clearOutputFolder: Bool?
    var projectDirectory: String?
    var addCredential: Bool?
    var credentialScopes: [String]?
    var licenseHeader: String?
    var namespace: String?
    var tag: String?
    var azureArm: Bool?
    var headAsBoolean: Bool?
    var title: String?
    var description: String?
    var clientSideValidation: Bool?
    var packageName: String?
    var packageVersion: String?
    var trace: Bool?

    /// Initialize from `CommandLineArguments` when running in standalone mode.
    /// - Parameter args: `CommandLineArguments` object.
    init() {
        let args = CommandLineArguments()
        inputFilename = args["--input-filename"]
        outputDirectory = args["--output-directory"]
        clearOutputFolder = Bool(args["--clear-output-folder"] ?? "False")
        projectDirectory = args["--project-directory"]
        addCredential = Bool(args["--add-credential"] ?? "False")
        credentialScopes = (args["--credential-scopes"] ?? "").components(separatedBy: " ")
        licenseHeader = args["--license-header"]
        namespace = args["--namespace"]
        tag = args["--tag"]
        azureArm = Bool(args["--azure-arm"] ?? "False")
        headAsBoolean = Bool(args["--head-as-boolean"] ?? "False")
        title = args["--title"]
        description = args["--description"]
        clientSideValidation = Bool(args["--client-side-validation"] ?? "False")
        packageName = args["--package-name"]
        packageVersion = args["--package-version"]
        trace = Bool(args["--trace"] ?? "False")
    }

    /// Initialize with RPC `ChannelClient` when running as an autorest plugin.
    /// - Parameter client: RPC `ChannelClient` object.
    /// - Parameter sessionId: RPC session ID
    func update(with client: ChannelClient, sessionId: String) {
        self.client = client
        self.sessionId = sessionId

        get(value: "input-filename") { self.inputFilename = $0 }
        get(value: "output-directory") { self.outputDirectory = $0 }
        get(value: "clear-output-folder") { self.clearOutputFolder = Bool($0 ?? "False") }
        get(value: "project-directory") { self.projectDirectory = $0 }
        get(value: "add-credential") { self.addCredential = Bool($0 ?? "False") }
        get(value: "credential-scopes") { self.credentialScopes = ($0 ?? "").components(separatedBy: " ") }
        get(value: "license-header") { self.licenseHeader = $0 }
        get(value: "namespace") { self.namespace = $0 }
        get(value: "tag") { self.tag = $0 }
        get(value: "azure-arm") { self.azureArm = Bool($0 ?? "False") }
        get(value: "head-as-boolean") { self.headAsBoolean = Bool($0 ?? "False") }
        get(value: "title") { self.title = $0 }
        get(value: "description") { self.description = $0 }
        get(value: "client-side-validation") { self.clientSideValidation = Bool($0 ?? "False") }
        get(value: "package-name") { self.packageName = $0 }
        get(value: "package-version") { self.packageVersion = $0 }
        get(value: "trace") { self.trace = Bool($0 ?? "False") }
    }

    func get(value: String, completion: @escaping (String?) -> Void) {
        guard let sessionId = self.sessionId, let client = self.client else {
            SharedLogger.fail("Unable to call GetValue")
        }
        let future = client.call(method: "GetValue", params: .list([.string(sessionId), .string(value)]))
        future.whenSuccess { result in
            switch result {
            case let .success(response):
                completion(response.asString)
            case .failure:
                completion(nil)
            }
        }
        future.whenFailure { error in
            SharedLogger.fail("Call GetValue failure \(error)")
        }
    }
}
