import Foundation
import NIO

public class RPCHandler: ChannelInboundHandler {
    public typealias InboundIn = JSONRequest
    public typealias OutboundOut = JSONResponse

    private let closure: RPCClosure
    private let log: URL

    public init(_ closure: @escaping RPCClosure) {
        self.closure = closure

        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }

        self.log = documentsUrl.appendingPathComponent("autorest-swift.log")
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        try? "Inside channelRead".appendLineToURL(fileURL: log)
        let request = unwrapInboundIn(data)
        try? "After unwrap inbound".appendLineToURL(fileURL: log)
        closure(request.method, RPCObject(request.params)) { result in
            let response: JSONResponse
            switch result {
            case let .success(handlerResult):
                // print("rpc handler returned success", handlerResult)
                try? "rpc handler returned success".appendToURL(fileURL: log)
                response = JSONResponse(id: request.id, result: handlerResult)
            case let .failure(handlerError):
                // print("rpc handler returned failure", handlerError)
                try? "rpc handler returned failure".appendToURL(fileURL: log)
                response = JSONResponse(id: request.id, error: handlerError)
            }
            context.channel.writeAndFlush(self.wrapOutboundOut(response), promise: nil)
        }
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "error", error)
        }
        switch error {
        case CodecError.badFraming, CodecError.badJSON:
            let response = JSONResponse(id: -1, errorCode: .parseError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            try? "Inside errorCaught badFraming".appendLineToURL(fileURL: log)
        case CodecError.requestTooLarge:
            let response = JSONResponse(id: -1, errorCode: .invalidRequest, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            try? "Inside errorCaught requestTooLarge".appendLineToURL(fileURL: log)
        default:
            let response = JSONResponse(id: -1, errorCode: .internalError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
            try? "Inside errorCaught default".appendLineToURL(fileURL: log)
        }
        // close the client connection
        context.close(promise: nil)
    }

    public func channelActive(context: ChannelHandlerContext) {
        try? "Inside channelActive".appendLineToURL(fileURL: log)

        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "connected")
        }
    }

    public func channelInactive(context: ChannelHandlerContext) {
        try? "Inside channelInactive".appendLineToURL(fileURL: log)
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "disconnected")
        }
    }

    public func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        try? "Inside userInboundEventTriggered".appendLineToURL(fileURL: log)

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
