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
import NIO

// swiftlint:disable force_try
class AutorestPlugin {
    let logger: FileLogger
    var client: ChannelClient!
    var server: ChannelServer!
    var sessionId: String?

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

    init() {
        self.logger = FileLogger(withFileName: "autorest-swift-debug.log")
    }

    func start() {
        // start up the client
        client = ChannelClient(group: eventLoopGroup)
        _ = try! client.start().wait()

        // start up the server
        server = ChannelServer(group: eventLoopGroup, closure: incomingHandler)
        _ = try! server.start().wait()

        // trap
        group.enter()
        let signalSource = trap(signal: Signal.INT) { _ in
            // shut down the client and server on a termination signal
            try! self.client.stop().wait()
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
    func incomingHandler(method: String, params: RPCObject, callback: (RPCResult) -> Void) {
        switch method.lowercased() {
        case "getpluginnames":
            callback(
                .success(.list([.string("swift")]))
            )
        case "process":
            plugin.sessionId = params.asList?.last?.asString ?? ""
            callback(.success(.bool(true)))
            initializationComplete()
        default:
            callback(.failure(RPCError(.invalidMethod)))
            logger.log("invalid method: \(method)")
        }
    }

    func initializationComplete() {
        guard let sessionId = sessionId else { fatalError() }
        let listInputsRequest: RPCObject = .list([.string(sessionId), .string("code-model-v4")])
        plugin.client.call(method: "ListInputs", params: listInputsRequest)
        // TODO: Retrieve the code model filename
        let filename = "code-model-v4.yaml"

        let readFileRequest: RPCObject = .list([.string(sessionId), .string(filename)])
        plugin.client.call(method: "ReadFile", params: readFileRequest)
        // TODO: Retrieve the code model contents
        let codeModelString = "..."

        // TODO: Run through AutoRest.Swift and then make WriteFile requests
    }
}
