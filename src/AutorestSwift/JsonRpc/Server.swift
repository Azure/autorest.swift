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

// TODO: Update license. Reproduced from: https://github.com/apple/swift-nio-examples/tree/master/json-rpc/Sources/JsonRpc

import Foundation
import NIO

public final class TCPServer {
    private let group: MultiThreadedEventLoopGroup
    private let config: Config
    private var channel: Channel?
    private let closure: RPCClosure

    public init(group: MultiThreadedEventLoopGroup, config: Config = Config(), closure: @escaping RPCClosure) {
        self.group = group
        self.config = config
        self.closure = closure
        self.state = .initializing
    }

    deinit {
        assert(self.state == .stopped)
    }

    public func start(host: String, port: Int) -> EventLoopFuture<TCPServer> {
        assert(state == .initializing)

        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.addTimeoutHandlers(self.config.timeout)
                    .flatMap {
                        channel.pipeline.addFramingHandlers(framing: self.config.framing)
                    }.flatMap {
                        channel.pipeline.addHandlers([
                            CodableCodec<JSONRequest, JSONResponse>(),
                            Handler(self.closure)
                        ])
                    }
            }
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)

        state = .starting("\(host):\(port)")
        return bootstrap.bind(host: host, port: port).flatMap { channel in
            self.channel = channel
            self.state = .started
            return channel.eventLoop.makeSucceededFuture(self)
        }
    }

    public func stop() -> EventLoopFuture<Void> {
        if state != .started {
            return group.next().makeFailedFuture(ServerError.notReady)
        }
        guard let channel = self.channel else {
            return group.next().makeFailedFuture(ServerError.notReady)
        }
        state = .stopping
        channel.closeFuture.whenComplete { _ in
            self.state = .stopped
        }
        return channel.close()
    }

    private var _state = State.initializing
    private let lock = NSLock()
    private var state: State {
        get {
            return lock.withLock {
                _state
            }
        }
        set {
            lock.withLock {
                _state = newValue
                print("\(self) \(_state)")
            }
        }
    }

    private enum State: Equatable {
        case initializing
        case starting(String)
        case started
        case stopping
        case stopped
    }

    public struct Config {
        public let timeout: TimeAmount
        public let framing: Framing

        public init(timeout: TimeAmount = TimeAmount.seconds(5), framing: Framing = .default) {
            self.timeout = timeout
            self.framing = framing
        }
    }
}

private class Handler: ChannelInboundHandler {
    public typealias InboundIn = JSONRequest
    public typealias OutboundOut = JSONResponse

    private let closure: RPCClosure

    public init(_ closure: @escaping RPCClosure) {
        self.closure = closure
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let request = unwrapInboundIn(data)
        closure(request.method, RPCObject(request.params)) { result in
            let response: JSONResponse
            switch result {
            case let .success(handlerResult):
                print("rpc handler returned success", handlerResult)
                response = JSONResponse(id: request.id, result: handlerResult)
            case let .failure(handlerError):
                print("rpc handler returned failure", handlerError)
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
            let response = JSONResponse(id: "unknown", errorCode: .parseError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        case CodecError.requestTooLarge:
            let response = JSONResponse(id: "unknown", errorCode: .invalidRequest, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        default:
            let response = JSONResponse(id: "unknown", errorCode: .internalError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        }
        // close the client connection
        context.close(promise: nil)
    }

    public func channelActive(context: ChannelHandlerContext) {
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "connected")
        }
    }

    public func channelInactive(context: ChannelHandlerContext) {
        if let remoteAddress = context.remoteAddress {
            print("client", remoteAddress, "disconnected")
        }
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
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
