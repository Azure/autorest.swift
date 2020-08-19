import Foundation
import NIO

struct JSONRequestWrapper: Codable {
    let request: JSONRequest
    let promise: EventLoopPromise<JSONResponse>?

    enum CodingKeys: String, CodingKey {
        case request
    }

    public init(request: JSONRequest, promise: EventLoopPromise<JSONResponse>?) {
        self.request = request
        self.promise = promise
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.request = try container.decode(JSONRequest.self, forKey: .request)
        self.promise = nil
    }

    public func encode(to encoder: Encoder) throws {
        try request.encode(to: encoder)
    }
}

internal enum ClientError: Error {
    case notReady
    case cantBind
    case timeout
    case connectionResetByPeer
}

// TODO: Does this need to suport ChannelOutboundHandler?
public class JSONRPCServerHandler: ChannelInboundHandler, RemovableChannelHandler {
    public typealias InboundIn = JSONRequest
    public typealias OutboundOut = JSONResponse

    private let closure: RPCClosure
    private let initComplete: InitComplete
    private let autoRestHandler: AutoRestHandler

    private let logger: Logger = Logger(withFileName: "autorest-swift-debug.log")

    init(_ autoRestHandler: AutoRestHandler) {
        self.closure = autoRestHandler.handle
        self.initComplete = autoRestHandler.initializationComplete
        self.autoRestHandler = autoRestHandler
        autoRestHandler.switchMode = switchMode
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger.logToURL("JSONRPCServerHandler channelRead")
        let request = unwrapInboundIn(data)

        closure(context, request.method, RPCObject(request.params)) { result in
            switch result {
            case let .success(handlerResult):
                let response: JSONResponse
                logger.logToURL("RPC handler closure returned success")
                response = JSONResponse(id: request.id, result: handlerResult)
                context.channel.writeAndFlush(self.wrapOutboundOut(response), promise: nil)
            case let .failure(handlerError):
                let response: JSONResponse
                logger.logToURL("rpc handler closure returned failure")
                response = JSONResponse(id: request.id, error: handlerError)
                context.channel.writeAndFlush(self.wrapOutboundOut(response), promise: nil)
            }
        }
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        if let remoteAddress = context.remoteAddress {
            logger.logToURL("client \(remoteAddress), error \(error)")
        }
        switch error {
        case CodecError.badFraming, CodecError.badJSON:
            let response = JSONResponse(id: -1, errorCode: .parseError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            logger.logToURL("Inside errorCaught badFraming")
        case CodecError.requestTooLarge:
            let response = JSONResponse(id: -1, errorCode: .invalidRequest, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            logger.logToURL("Inside errorCaught requestTooLarge")
        default:
            let response = JSONResponse(id: -1, errorCode: .internalError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            logger.logToURL("Inside errorCaught default")
        }
        // close the client connection
        context.close(promise: nil)
    }

    public func channelActive(context _: ChannelHandlerContext) {
        logger.logToURL("Inside JSONRPCServerHandler channelActive")
    }

    public func channelInactive(context _: ChannelHandlerContext) {
        logger.logToURL("Inside JSONRPCServerHandler channelInactive")
    }

    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        logger.logToURL("Inside userInboundEventTriggered")

        if (event as? IdleStateHandler.IdleStateEvent) == .read {
            errorCaught(context: context, error: ServerError.timeout)
        } else {
            context.fireUserInboundEventTriggered(event)
        }
    }

    public func switchMode(context: ChannelHandlerContext) {
        let future = context.pipeline.removeHandler(name: "AutorestServer").flatMap {
            context.pipeline.removeHandler(name: "JSONRPCServerHandler").flatMap {
                context.pipeline.addHandler(
                    CodableCodec<JSONResponse, JSONRequest>(),
                    name: "AutorestClient"
                ).flatMap {
                    context.pipeline.addHandler(
                        JSONRPCClientHandler(self.initComplete),
                        name: "JSONRPCClientHandler"
                    )
                }
            }
        }

        future.whenSuccess {
            self.logger.logToURL("JSONRPCServerHandler switches to client mode successfully")
        }
        future.whenFailure { error in
            self.logger.logToURL("rpc handler remove AutorestServer handler faile: \(error)")
        }
    }
}

internal enum ServerError: Error {
    case notReady
    case cantBind
    case timeout
}
