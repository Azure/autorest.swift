import Foundation
import NIO
import os.log

class AutoRestPlugin {
    let logger: Logger = Logger(withFileName: "autorest-swift-debug.log")
    var sessionId: String? = ""
    let group: MultiThreadedEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    var id = 3

    public func start() throws -> EventLoopFuture<AutoRestPlugin> {
        logger.logToURL("Starting NIO pipeline")

        let autotResthandler = AutoRestHandler(withPlugin: self)
        let channel = NIOPipeBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addFramingHandlers(framing: .jsonpos)
                    .flatMap {
                        channel.pipeline.addHandler(CodableCodec<JSONRequest, JSONResponse>(), name: "AutorestServer")
                    }.flatMap {
                        channel.pipeline.addHandler(
                            JSONRPCServerHandler(autotResthandler),
                            name: "JSONRPCServerHandler"
                        )
                    }
            }
            .withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO)

        return channel.eventLoop.makeSucceededFuture(self)
    }

    public func call(context: ChannelHandlerContext, method: String, params: RPCObject) -> EventLoopFuture<RPCResult> {
        logger.logToURL("call \(method)")

        id += 1
        let promise: EventLoopPromise<JSONResponse> = context.channel.eventLoop.makePromise()
        let request = JSONRequest(id: id, method: method, params: JSONObject(params))
        let requestWrapper = JSONRequestWrapper(request: request, promise: promise)

        let future = context.channel.writeAndFlush(requestWrapper)
        future.cascadeFailure(to: promise) // if write fails

        return future.flatMap {
            promise.futureResult.map { RPCResult($0) }
        }
    }
}
