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

public final class ChannelServer {
    private let group: MultiThreadedEventLoopGroup
    private var channel: Channel?
    private let handler: RPCClosure

    public init(group: MultiThreadedEventLoopGroup, handler: @escaping RPCClosure) {
        self.group = group
        self.handler = handler
        self.state = .initializing
    }

    deinit {
        assert(self.state == .stopped)
    }

    public func start() -> EventLoopFuture<ChannelServer> {
        assert(state == .initializing)

        let bootstrap = NIOPipeBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addFramingHandlers(framing: .jsonpos)
                    .flatMap {
                        channel.pipeline.addHandler(CodableCodec<JSONRequest, JSONResponse>(), name: "AutorestServer")
                    }.flatMap {
                        channel.pipeline.addHandler(
                            ServerHandler(self.handler),
                            name: "ServerHandler"
                        )
                    }
            }.withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO)

        state = .starting
        return bootstrap.eventLoop.makeSucceededFuture(self)
    }

    public func stop() -> EventLoopFuture<Void> {
        SharedLogger.info("Server stop")
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

    private var _state = ChannelState.initializing
    private let lock = NSLock()
    private var state: ChannelState {
        get {
            return lock.withLock {
                _state
            }
        }
        set {
            lock.withLock {
                _state = newValue
            }
        }
    }
}

private class ServerHandler: ChannelInboundHandler, RemovableChannelHandler {
    public typealias InboundIn = JSONRequest
    public typealias OutboundOut = JSONResponse

    private let closure: RPCClosure

    public init(_ closure: @escaping RPCClosure) {
        self.closure = closure
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        SharedLogger.info("Server channelRead")
        let request = unwrapInboundIn(data)
        closure(context, request.id, request.method, RPCObject(request.params)) { result in
            let response: JSONResponse
            switch result {
            case let .success(handlerResult):
                SharedLogger.debug("RPC handler returned success \(handlerResult)")
                response = JSONResponse(id: request.id ?? 0, result: handlerResult)
            case let .failure(handlerError):
                SharedLogger.error("RPC handler returned failure \(handlerError)")
                response = JSONResponse(id: request.id ?? 0, error: handlerError)
            }
            context.channel.writeAndFlush(self.wrapOutboundOut(response), promise: nil)
        }
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        SharedLogger.error("Server Handler errorCaught. error=\(error)")

        switch error {
        case CodecError.badFraming, CodecError.badJSON:
            let response = JSONResponse(id: 0, errorCode: .parseError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        case CodecError.requestTooLarge:
            let response = JSONResponse(id: 0, errorCode: .invalidRequest, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        default:
            let response = JSONResponse(id: 0, errorCode: .internalError, error: error)
            context.channel.writeAndFlush(wrapOutboundOut(response), promise: nil)
        }
        // close the client connection
        context.close(promise: nil)
    }
}
