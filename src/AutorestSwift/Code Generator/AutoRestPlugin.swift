import Foundation
import NIO
import os.log

class AutoRestPlugin {
    var logger: Logger!
    var sessionId: String?

    public func start() throws -> EventLoopFuture<AutoRestPlugin> {
        logger = Logger(withFileName: "autorest-swift-debug.log")
        logger.logToURL("Starting NIO pipeline")
        let handler = AutoRestHandler(withPlugin: self)
        let channel = NIOPipeBootstrap(group: MultiThreadedEventLoopGroup(numberOfThreads: 1))
            .channelInitializer { channel in
                channel.pipeline.addTimeoutHandlers(TimeAmount.seconds(5 * 100))
                    .flatMap {
                        channel.pipeline.addFramingHandlers(framing: .jsonpos)
                    }.flatMap {
                        channel.pipeline.addHandler(CodableCodec<JSONRequest, JSONResponse>(), name: "AutoRestServer")
                    }.flatMap {
                        channel.pipeline.addHandler(JSONRPCHandler(handler.handle))
                    }
            }
            .withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO)

        return channel.eventLoop.makeSucceededFuture(self)
    }

    public func call(method: String, params: RPCObject) -> EventLoopFuture<RPCResult> {
        // FIXME: Fix this Implmentation
//        if .connected != self.state {
//             return self.group.next().makeFailedFuture(ClientError.notReady)
//         }
//         guard let channel = self.channel else {
//             return self.group.next().makeFailedFuture(ClientError.notReady)
//         }
//         let promise: EventLoopPromise<JSONResponse> = channel.eventLoop.makePromise()
//         let request = JSONRequest(id: NSUUID().uuidString, method: method, params: JSONObject(params))
//         let requestWrapper = JSONRequestWrapper(request: request, promise: promise)
//         let future = channel.writeAndFlush(requestWrapper)
//         future.cascadeFailure(to: promise) // if write fails
//         return future.flatMap {
//             promise.futureResult.map { Result($0) }
//         }
    }
}
