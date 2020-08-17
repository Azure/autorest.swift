import Foundation
import NIO
import os.log

class Server {
    // let config = Config()

    public func start() throws -> EventLoopFuture<Server> {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }
        let log = documentsUrl.appendingPathComponent("autorest-swift.log")
        // do {
        let autoRestHandler = AutoRestHandler()
        try? "Start NIO pipe".appendToURL(fileURL: log)

        let channel = NIOPipeBootstrap(group: MultiThreadedEventLoopGroup(numberOfThreads: 5))
            .channelInitializer { channel in
                channel.pipeline.addTimeoutHandlers(TimeAmount.seconds(5 * 100))
                    .flatMap {
                        channel.pipeline.addFramingHandlers(framing: .jsonpos)
                    }.flatMap {
                        channel.pipeline.addHandlers([
                            CodableCodec<JSONRequest, JSONResponse>(),
                            RPCHandler(autoRestHandler.handle)
                        ])
                    }
                // let autoRestHandler = AutoRestHandler()
                // return channel.pipeline.addHandler(RPCHandler(autoRestHandler.handle))
            }
            .withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO)

        return channel.eventLoop.makeSucceededFuture(self)
        // } catch {
        //     try? "error Start NIO pipe".write(to: log, atomically: true, encoding: .utf8)
        // }
    }
}
