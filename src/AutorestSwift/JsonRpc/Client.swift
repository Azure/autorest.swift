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

public final class ChannelClient {
    public let group: MultiThreadedEventLoopGroup
    public let config: Config
    private var channel: Channel?

    public init(group: MultiThreadedEventLoopGroup, config: Config = Config()) {
        self.group = group
        self.config = config
        self.channel = nil
        self.state = .initializing
    }

    deinit {
        assert(self.state == .stopped)
    }

    public func start() -> EventLoopFuture<ChannelClient> {
        assert(state == .initializing)

        let bootstrap = NIOPipeBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addTimeoutHandlers(self.config.timeout)
                    .flatMap {
                        channel.pipeline.addFramingHandlers(framing: self.config.framing)
                    }.flatMap {
                        channel.pipeline.addHandlers([
                            CodableCodec<JSONResponse, JSONRequest>(),
                            Handler()
                        ])
                    }
            }.withPipes(inputDescriptor: STDOUT_FILENO, outputDescriptor: STDIN_FILENO)

        state = .starting
        return bootstrap.eventLoop.makeSucceededFuture(self)
    }

    public func stop() -> EventLoopFuture<Void> {
        if state != .started {
            return group.next().makeFailedFuture(ClientError.notReady)
        }
        guard let channel = self.channel else {
            return group.next().makeFailedFuture(ClientError.notReady)
        }
        state = .stopping
        channel.closeFuture.whenComplete { _ in
            self.state = .stopped
        }
        channel.close(promise: nil)
        return channel.closeFuture
    }

    public func call(method: String, params: RPCObject) -> EventLoopFuture<Result> {
        if state != .started {
            return group.next().makeFailedFuture(ClientError.notReady)
        }
        guard let channel = self.channel else {
            return group.next().makeFailedFuture(ClientError.notReady)
        }
        let promise: EventLoopPromise<JSONResponse> = channel.eventLoop.makePromise()
        let request = JSONRequest(id: Int(NSUUID().uuidString) ?? 0, method: method, params: JSONObject(params))
        let requestWrapper = JSONRequestWrapper(request: request, promise: promise)
        let future = channel.writeAndFlush(requestWrapper)
        future.cascadeFailure(to: promise) // if write fails
        return future.flatMap {
            promise.futureResult.map { Result($0) }
        }
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
                print("\(self) \(_state)")
            }
        }
    }

    public typealias Result = ResultType<RPCObject, Error>

    public struct Error: Swift.Error, Equatable {
        public let kind: Kind
        public let description: String

        init(kind: Kind, description: String) {
            self.kind = kind
            self.description = description
        }

        internal init(_ error: JSONError) {
            self.init(
                kind: JSONErrorCode(rawValue: error.code).map { Kind($0) } ?? .otherServerError,
                description: error.message
            )
        }

        public enum Kind {
            case invalidMethod
            case invalidParams
            case invalidRequest
            case invalidServerResponse
            case otherServerError

            internal init(_ code: JSONErrorCode) {
                switch code {
                case .invalidRequest:
                    self = .invalidRequest
                case .methodNotFound:
                    self = .invalidMethod
                case .invalidParams:
                    self = .invalidParams
                case .parseError:
                    self = .invalidServerResponse
                case .internalError, .other:
                    self = .otherServerError
                }
            }
        }
    }
}

private class Handler: ChannelInboundHandler, ChannelOutboundHandler {
    public typealias InboundIn = JSONResponse
    public typealias OutboundIn = JSONRequestWrapper
    public typealias OutboundOut = JSONRequest

    private var queue = CircularBuffer<(Int, EventLoopPromise<JSONResponse>?)>()

    private let logger = FileLogger(withFileName: "autorest-swift-debug.log")

    // private let initComplete: InitComplete

    //  init(_ initComplete: @escaping InitComplete) {
    //      self.initComplete = initComplete
    //  }

    // outbound
    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        let requestWrapper = unwrapOutboundIn(data)
        queue.append((requestWrapper.request.id, requestWrapper.promise))
        context.write(wrapOutboundOut(requestWrapper.request), promise: promise)
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        logger.log("JSONRPCClientHandler channelRead")
        if queue.isEmpty {
            return context.fireChannelRead(data) // already complete
        }
        let promise = queue.removeFirst().1
        let response = unwrapInboundIn(data)
        promise?.succeed(response)
    }

    public func handlerAdded(context _: ChannelHandlerContext) {
        logger.log("Client Handler handlerAdded")
        //    initComplete(context)
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        logger.log("Client Handler errorCaught")
        if let remoteAddress = context.remoteAddress {
            print("server", remoteAddress, "error", error)
        }
        if queue.isEmpty {
            return context.fireErrorCaught(error) // already complete
        }
        let item = queue.removeFirst()
        let requestId = item.0
        let promise = item.1
        switch error {
        case CodecError.requestTooLarge, CodecError.badFraming, CodecError.badJSON:
            promise?.succeed(JSONResponse(id: requestId, errorCode: .parseError, error: error))
        default:
            promise?.fail(error)
            // close the connection
            context.close(promise: nil)
        }
    }

    public func channelActive(context: ChannelHandlerContext) {
        if let remoteAddress = context.remoteAddress {
            print("server", remoteAddress, "connected")
        }
    }

    public func channelInactive(context: ChannelHandlerContext) {
        if let remoteAddress = context.remoteAddress {
            print("server ", remoteAddress, "disconnected")
        }
        if !queue.isEmpty {
            errorCaught(context: context, error: ClientError.connectionResetByPeer)
        }
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        if (event as? IdleStateHandler.IdleStateEvent) == .read {
            errorCaught(context: context, error: ClientError.timeout)
        } else {
            context.fireUserInboundEventTriggered(event)
        }
    }
}

private struct JSONRequestWrapper: Codable {
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

internal extension ResultType where Value == RPCObject, Error == ChannelClient.Error {
    init(_ response: JSONResponse) {
        if let result = response.result {
            self = .success(RPCObject(result))
        } else if let error = response.error {
            self = .failure(ChannelClient.Error(error))
        } else {
            self = .failure(ChannelClient.Error(kind: .invalidServerResponse, description: "invalid server response"))
        }
    }
}
