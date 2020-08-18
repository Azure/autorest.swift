import Foundation
import NIO
import os.log

class AutoRestPlugin {
    public func start() throws -> EventLoopFuture<AutoRestPlugin> {
        let logger = Logger(withFileName: "autorest-swift-debug.log")

        let autoRestHandler = AutoRestHandler()
        logger.logToURL("Start NIO pipe")

        let channel = NIOPipeBootstrap(group: MultiThreadedEventLoopGroup(numberOfThreads: 5))
            .channelInitializer { channel in
                channel.pipeline.addTimeoutHandlers(TimeAmount.seconds(5 * 100))
                    .flatMap {
                        channel.pipeline.addFramingHandlers(framing: .jsonpos)
                    }.flatMap {
                        channel.pipeline.addHandler(CodableCodec<JSONRequest, JSONResponse>(), name: "AutorestServer")
                    }.flatMap {
                        channel.pipeline.addHandler(JSONRPCHandler(autoRestHandler.handle))
                    }
            }
            .withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO)

        return channel.eventLoop.makeSucceededFuture(self)
    }
}
