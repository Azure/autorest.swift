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
    private let group: MultiThreadedEventLoopGroup
    public let config: Config
    private var context: ChannelHandlerContext?
    private let processCallback: ProcessCallback

    // TODO: get this value based on last response id from AutoRest
    var id = 3

    public init(
        group: MultiThreadedEventLoopGroup,
        config: Config = Config(),
        processCallback: @escaping ProcessCallback
    ) {
        self.group = group
        self.config = config
        self.processCallback = processCallback
        self.state = .initializing
    }

    deinit {
        assert(self.state == .stopped)
    }

    public func start(context: ChannelHandlerContext) {
        assert(state == .initializing)

        let future = context.pipeline.removeHandler(name: "AutorestServer").flatMap {
            context.pipeline.removeHandler(name: "ServerHandler").flatMap {
                context.pipeline.addHandler(
                    CodableCodec<JSONResponse, JSONRequest>(),
                    name: "AutorestClient"
                ).flatMap {
                    context.pipeline.addHandler(
                        Handler(self.initalizationComplete),
                        name: "ClientHandler"
                    )
                }
            }
        }

        future.whenFailure { error in
            FileLogger.shared.logAndFail("Switch to client mode failed: \(error)")
        }
    }

    private func initalizationComplete(context: ChannelHandlerContext) {
        FileLogger.shared.log("initalizationComplete called")
        state = .started
        self.context = context
        processCallback()
    }

    public func stop() {
        state = .stopped
    }

    public func call(method: String, params: RPCObject) -> EventLoopFuture<RPCResult> {
        if state != .started {
            FileLogger.shared.log("Client call failed. State is not started")
            return group.next().makeFailedFuture(ClientError.notReady)
        }
        guard let context = self.context else {
            FileLogger.shared.log("Client call failed. Content is nil")
            return group.next().makeFailedFuture(ClientError.notReady)
        }

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
                FileLogger.shared.log("\(self) \(_state)")
            }
        }
    }
}

private class Handler: ChannelInboundHandler, ChannelOutboundHandler {
    public typealias InboundIn = JSONResponse
    public typealias OutboundIn = JSONRequestWrapper
    public typealias OutboundOut = JSONRequest

    private var queue = CircularBuffer<(Int, EventLoopPromise<JSONResponse>)>()

    private let initComplete: InitCompleteCallback

    init(_ initComplete: @escaping InitCompleteCallback) {
        self.initComplete = initComplete
    }

    // outbound
    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        FileLogger.shared.log("Client Handler write")
        let requestWrapper = unwrapOutboundIn(data)
        queue.append((requestWrapper.request.id, requestWrapper.promise))
        context.write(wrapOutboundOut(requestWrapper.request), promise: promise)
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        FileLogger.shared.log("Client Handler channelRead")
        if queue.isEmpty {
            return context.fireChannelRead(data) // already complete
        }
        let promise = queue.removeFirst().1
        let response = unwrapInboundIn(data)
        promise.succeed(response)
    }

    public func handlerAdded(context: ChannelHandlerContext) {
        FileLogger.shared.log("Client Handler handlerAdded")
        initComplete(context)
    }

    public func errorCaught(context: ChannelHandlerContext, error: Error) {
        FileLogger.shared.log("Client Handler errorCaught")
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
            promise.succeed(JSONResponse(id: requestId, errorCode: .parseError, error: error))
        default:
            promise.fail(error)
            // close the connection
            context.close(promise: nil)
        }
    }

    public func channelActive(context _: ChannelHandlerContext) {
        FileLogger.shared.log("Client Handler channelActive")
    }

    public func channelInactive(context: ChannelHandlerContext) {
        FileLogger.shared.log("Client Handler channelInactive")

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

internal struct JSONRequestWrapper {
    let request: JSONRequest
    let promise: EventLoopPromise<JSONResponse>
}

internal extension ResultType where Value == RPCObject, Error == RPCError {
    init(_ response: JSONResponse) {
        if let result = response.result {
            self = .success(RPCObject(result))
        } else if let error = response.error {
            self = .failure(RPCError(error))
        } else {
            self = .failure(RPCError(kind: .invalidServerResponse, description: "invalid server response"))
        }
    }
}
