import Foundation
import NIO

// TODO: Does this need to suport ChannelOutboundHandler?
public class JSONRPCHandler: ChannelInboundHandler {
    public typealias InboundIn = JSONRequest
    public typealias OutboundOut = JSONResponse

    private let closure: RPCClosure
    private let logger: Logger = Logger(withFileName: "autorest-swift-debug.log")

    public init(_ closure: @escaping RPCClosure) {
        self.closure = closure
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger.logToURL("JSONRPCHandler channelRead")
        let request = unwrapInboundIn(data)

        closure(request.method, RPCObject(request.params)) { result in
            switch result {
            case let .success(handlerResult, resultType, _):

                if resultType == RPCObjectType.response {
                    let response: JSONResponse
                    logger.logToURL("RPC handler closure returned success")
                    response = JSONResponse(id: request.id, result: handlerResult)
                    context.channel.writeAndFlush(self.wrapOutboundOut(response), promise: nil)
                } else {
                    logger.logToURL("RPC handler remove AutorestServer handler")
                    let future = context.pipeline.removeHandler(name: "AutorestServer").flatMap {
                        context.pipeline.addHandler(
                            CodableCodec<JSONResponse, JSONRequest>(),
                            name: "AutorestClient",
                            position: .first
                        )
                    }

                    future.whenSuccess {
                        self.logger.logToURL("RPC handler removed AutorestServer handler successfully")

                        /*  let request2 = JSONRequest(
                             id: request.id + 1,
                             method: method,
                             params: JSONObject(handlerResult)
                         ) */

                        //   let d3 = EventLoopPromise<Void>(eventLoop: <#EventLoop#>, file: <#StaticString#>, line: <#UInt#>)
                        /*  context.channel.writeAndFlush(
                             self
                                 .wrapInboundOut(JSONRequest(
                                     id: request.id + 1,
                                     method: method,
                                     params: JSONObject(handlerResult)
                                 )),
                             promise: nil
                         )*/
                    }
                    future.whenFailure { error in
                        self.logger.logToURL("rpc handler remove AutorestServer handler faile: \(error)")
                    }
                }
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

    public func channelActive(context: ChannelHandlerContext) {
        logger.logToURL("Inside channelActive")
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "connected")
        }
    }

    public func channelInactive(context: ChannelHandlerContext) {
        logger.logToURL("Inside channelInactive")
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "disconnected")
        }
    }

    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        logger.logToURL("Inside userInboundEventTriggered")

        if (event as? IdleStateHandler.IdleStateEvent) == .read {
            errorCaught(context: context, error: ServerError.timeout)
        } else {
            context.fireUserInboundEventTriggered(event)
        }
    }
}

internal enum ServerError: Error {
    case notReady
    case cantBind
    case timeout
}
