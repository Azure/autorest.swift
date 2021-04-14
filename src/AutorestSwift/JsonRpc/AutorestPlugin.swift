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

// swiftlint:disable force_try
class AutorestPlugin {
    var client: ChannelClient!
    var server: ChannelServer!
    var sessionId: String!
    var processRequestId: Int!

    var eventLoop = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)

    private enum Signal: Int32 {
        case HUP = 1
        case INT = 2
        case QUIT = 3
        case ABRT = 6
        case KILL = 9
        case ALRM = 14
        case TERM = 15
    }

    func start() {
        // Start up the server. It will switch to client mode later on.
        server = ChannelServer(group: eventLoop, handler: serverHandler)
        _ = try! server.start().wait()

        // Create the client but do not start it
        client = ChannelClient(group: eventLoop, handler: clientHandler)

        // Trap to catch an abort signal via CTRL+C
        let group = DispatchGroup()
        group.enter()
        let signalSource = trap(signal: Signal.INT) { _ in
            // shut down the client and server on a termination signal
            self.client.stop()
            self.server.stop().whenComplete { _ in
                group.leave()
            }
        }
        group.wait()
        signalSource.cancel()
    }

    private func trap(signal sig: Signal, handler: @escaping (Signal) -> Void) -> DispatchSourceSignal {
        let signalSource = DispatchSource.makeSignalSource(signal: sig.rawValue)
        signal(sig.rawValue, SIG_IGN)
        signalSource.setEventHandler(handler: {
            signalSource.cancel()
            handler(sig)
        })
        signalSource.resume()
        return signalSource
    }

    /// The handler for incoming messages in server mode
    func serverHandler(
        context: ChannelHandlerContext,
        id: Int?,
        method: String,
        params: RPCObject,
        callback: (RPCResult) -> Void
    ) {
        SharedLogger.info("AutorestPlugin serverHandler method: \(method) id: \(id ?? -1)")
        switch method.lowercased() {
        case "getpluginnames":
            callback(
                .success(.list([.string("swift")]))
            )
        case "process":
            // Once a "process" message is received, switch to client mode
            sessionId = params.asList?.last?.asString
            processRequestId = id
            server.stop().whenComplete { _ in
                self.client.start(context: context, id: self.processRequestId)
            }
        default:
            callback(.failure(RPCError(kind: .invalidMethod, description: "Incoming Handler get invalid method")))
            SharedLogger.fail("invalid method: \(method)")
        }
    }

    /// The handler for client mode
    func clientHandler() {
        SharedLogger.info("AutorestPlugin clientHandler")
        let listInputsRequest: RPCObject = .list([.string(sessionId), .string("code-model-v4")])

        let future = client.call(method: "ListInputs", params: listInputsRequest)
        future.whenSuccess { result in
            switch result {
            case let .success(response):
                self.handleListInputs(response: response)
            case let .failure(error):
                SharedLogger.fail("Call ListInputs failure \(error)")
            }
        }
        future.whenFailure { error in
            SharedLogger.fail("Call ListInputs failure \(error)")
        }
    }

    func handleListInputs(response: RPCObject) {
        guard let filename = response.asList?.first?.asString else {
            SharedLogger.fail("handleListInputs filename is nil")
        }
        let readFileRequest: RPCObject = .list([.string(sessionId), .string(filename)])
        let future = client.call(method: "ReadFile", params: readFileRequest)
        future.whenSuccess { result in
            switch result {
            case let .success(response):
                self.handleReadFile(response: response)
            case let .failure(error):
                SharedLogger.fail("Call ReadFile failure \(error)")
            }
        }
        future.whenFailure { error in
            SharedLogger.fail("Call ReadFile failure \(error)")
        }
    }

    private func iterateDirectory(directory: URL) -> [String] {
        var generatedFileList: [String] = []

        guard let enumerator =
            FileManager.default.enumerator(atPath: directory.path) else {
            SharedLogger.fail("Iterate Directory fail")
        }

        while let file = enumerator.nextObject() as? String {
            if file.hasSuffix(".swift") || file.hasSuffix(".md") || file.hasSuffix(".yml") {
                generatedFileList.append(file)
            }
        }

        return generatedFileList
    }

    func handleReadFile(response: RPCObject) {
        guard let codeModel = response.asString else {
            SharedLogger.fail("Unable to retrieve code model from Autorest.")
        }
        Manager.shared.configure(input: codeModel, client: client, sessionId: sessionId) {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let encoded = try! encoder.encode(Manager.shared.args)
            let arguments = String(data: encoded, encoding: .utf8)!
            SharedLogger.info("Autorest Configuration: \(arguments)")
            do {
                try Manager.shared.run()

                guard let packageUrl = Manager.shared.config?.tempPackageUrl else {
                    SharedLogger.fail("Unable to get packageUrl")
                }
                let generatedFileList = self.iterateDirectory(directory: packageUrl)
                generatedFileList.forEach {
                    self.sendWriteFile(fileName: $0, packageUrl: packageUrl)
                }
                self.sendProcessResponse()
            } catch {
                SharedLogger.fail("Code generation failure: \(error)")
            }
        }
    }

    func sendWriteFile(fileName: String, packageUrl: URL) {
        do {
            let fileUrl = packageUrl.appendingPathComponent(fileName)
            let fileContent = try String(contentsOf: fileUrl)

            let writeFileRequest: RPCObject = .list([.string(sessionId), .string(fileName), .string(fileContent)])
            let future = client.call(method: "WriteFile", params: writeFileRequest)
            future.whenSuccess { result in
                switch result {
                case let .success(response):
                    SharedLogger.debug("Call WriteFile succeed: \(response)")
                case let .failure(error):
                    SharedLogger.fail("Call WriteFile failure: \(error)")
                }
            }
            future.whenFailure { error in
                SharedLogger.fail("Call WriteFile failure: \(error)")
            }
        } catch {
            SharedLogger.fail("Call WriteFile failure: \(error)")
        }
    }

    func sendProcessResponse() {
        // Setup the client to write JSONResponse in output handler.
        // When Handler is setup, write JSONResponse to the handler's channel
        SharedLogger.info("SendProcessResponse")
        client.setupHandler { context in
            let response: JSONResponse
            response = JSONResponse(id: self.processRequestId, result: JSONObject(.bool(true)))
            let future = context.channel.writeAndFlush(response)
            future.whenFailure { error in
                SharedLogger.fail("Send Process Response failure: \(error)")
            }
        }
    }
}
