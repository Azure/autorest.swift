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

    // TODO: Increase when working correctly
    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    private let group = DispatchGroup()

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
        client = ChannelClient(group: eventLoopGroup, processCallback: handleProcess)

        // start up the server
        server = ChannelServer(group: eventLoopGroup, closure: incomingHandler)
        _ = try! server.start().wait()

        // trap
        group.enter()
        let signalSource = trap(signal: Signal.INT) { _ in
            // shut down the client and server on a termination signal
            self.client.stop()
            self.server.stop().whenComplete { _ in
                self.group.leave()
            }
        }
        group.wait()
        // cleanup
        signalSource.cancel()
    }

    private func trap(signal sig: Signal, handler: @escaping (Signal) -> Void) -> DispatchSourceSignal {
        let queue = DispatchQueue(label: "AutorestSwiftServer")
        let signalSource = DispatchSource.makeSignalSource(signal: sig.rawValue, queue: queue)
        signal(sig.rawValue, SIG_IGN)
        signalSource.setEventHandler(handler: {
            signalSource.cancel()
            handler(sig)
        })
        signalSource.resume()
        return signalSource
    }

    /// The handler for incoming messages
    func incomingHandler(
        context: ChannelHandlerContext,
        id: Int?,
        method: String,
        params: RPCObject,
        callback: (RPCResult) -> Void
    ) {
        switch method.lowercased() {
        case "getpluginnames":
            callback(
                .success(.list([.string("swift")]))
            )
        case "process":
            plugin.sessionId = params.asList?.last?.asString
            processRequestId = id
            startChannelClient(context: context)
        default:
            callback(.failure(RPCError(kind: .invalidMethod, description: "Incoming Handler get invalid method")))
            FileLogger.shared.logAndFail("invalid method: \(method)")
        }
    }

    func startChannelClient(context: ChannelHandlerContext) {
        client.start(context: context, id: processRequestId)
    }

    func handleProcess() {
        let listInputsRequest: RPCObject = .list([.string(sessionId), .string("code-model-v4")])
        let future = plugin.client.call(method: "ListInputs", params: listInputsRequest)
        future.whenSuccess { result in
            switch result {
            case let .success(response):
                self.handleListInputs(response: response)
            case let .failure(error):
                FileLogger.shared.logAndFail("Call ListInputs failure \(error)")
            }
        }
        future.whenFailure { error in
            FileLogger.shared.logAndFail("Call ListInputs failure \(error.localizedDescription)")
        }
    }

    func handleListInputs(response: RPCObject) {
        guard let filename = response.asList?.first?.asString else {
            FileLogger.shared.logAndFail("handleListInputs filename is nil")
        }
        let readFileRequest: RPCObject = .list([.string(sessionId), .string(filename)])
        let future = plugin.client.call(method: "ReadFile", params: readFileRequest)
        future.whenSuccess { result in
            switch result {
            case let .success(response):
                self.handleReadFile(response: response)
            case let .failure(error):
                FileLogger.shared.logAndFail("Call ReadFile failure \(error)")
            }
        }
        future.whenFailure { error in
            FileLogger.shared.logAndFail("Call ReadFile failure \(error.localizedDescription)")
        }
    }

    private func iterateDirectory(directory: URL) -> [String] {
        var generatedFileList: [String] = []

        guard let enumerator =
            FileManager.default.enumerator(atPath: directory.path) else {
            FileLogger.shared.logAndFail("Iterate Directory fail")
        }

        while let file = enumerator.nextObject() as? String {
            if file.hasSuffix(".swift") || file.hasSuffix(".md") || file.hasSuffix(".yml") {
                FileLogger.shared.log("Found file in generated directory: \(file)")
                generatedFileList.append(file)
            }
        }

        return generatedFileList
    }

    func handleReadFile(response: RPCObject) {
        guard let codeModel = response.asString else {
            FileLogger.shared.logAndFail("Unable to retrieve code model from Autorest.")
        }
        let manager = Manager(withString: codeModel)
        do {
            try manager.run()

            guard let packageUrl = manager.packageUrl else {
                FileLogger.shared.logAndFail("Unable to get packageUrl")
            }

            let generatedFileListQueue = iterateDirectory(directory: packageUrl)
            generatedFileListQueue.forEach {
                sendWriteFile(fileName: $0, packageUrl: packageUrl)
            }

            sendProcessResponse()
        } catch {
            FileLogger.shared.logAndFail("Code generation failure: \(error)")
        }
    }

    func sendWriteFile(fileName: String, packageUrl: URL) {
        do {
            let fileUrl = packageUrl.appendingPathComponent(fileName)
            let fileContent = try String(contentsOf: fileUrl)

            let writeFileRequest: RPCObject = .list([.string(sessionId), .string(fileName), .string(fileContent)])
            let future = plugin.client.call(method: "WriteFile", params: writeFileRequest)
            future.whenSuccess { result in
                switch result {
                case let .success(response):
                    FileLogger.shared.logAndFail("Call WriteFile succeed \(response)")
                case let .failure(error):
                    FileLogger.shared.logAndFail("Call WriteFile failure: \(error)")
                }
            }
            future.whenFailure { error in
                FileLogger.shared.logAndFail("Call WriteFile failure: \(error.localizedDescription)")
            }
        } catch {
            FileLogger.shared.logAndFail("Call WriteFile failure: \(error.localizedDescription)")
        }
    }

    func sendProcessResponse() {
        // Setup the client to write JSONResponse in output handler.
        // When Handler is setup, write JSONResponse to the handler's channel
        client.setupHandler { context in
            let response: JSONResponse
            response = JSONResponse(id: self.processRequestId, result: JSONObject(.bool(true)))
            let future = context.channel.writeAndFlush(response)
            future.whenFailure { error in
                FileLogger.shared.logAndFail("Send Process Response failure: \(error.localizedDescription)")
            }
        }
    }
}
