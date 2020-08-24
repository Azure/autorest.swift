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
import NIOFoundationCompat

private let maxPayload = 1_000_000 // 1MB
internal extension ChannelPipeline {
    func addTimeoutHandlers(_ timeout: TimeAmount) -> EventLoopFuture<Void> {
        return addHandlers([IdleStateHandler(readTimeout: timeout), HalfCloseOnTimeout()])
    }
}

internal extension ChannelPipeline {
    func addFramingHandlers(framing: Framing) -> EventLoopFuture<Void> {
        switch framing {
        case .jsonpos:
            return addHandlers([
                ByteToMessageHandler(ContentLengthHeaderFrameDecoder()),
                MessageToByteHandler(ContentLengthHeaderFrameEncoder())
            ])
        default:
            fatalError("\(self) not supported.")
        }
    }
}

// aggregate bytes till delimiter and add delimiter at end
internal final class NewlineEncoder: ByteToMessageDecoder, MessageToByteEncoder {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = ByteBuffer
    public typealias OutboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer

    private let delimiter1 = UInt8(ascii: "\r")
    private let delimiter2 = UInt8(ascii: "\n")

    private var lastIndex = 0

    // inbound
    public func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        guard buffer.readableBytes < maxPayload else {
            throw CodecError.requestTooLarge
        }
        guard buffer.readableBytes >= 3 else {
            return .needMoreData
        }

        // try to find a payload by looking for a \r\n delimiter
        let readableBytesView = buffer.readableBytesView.dropFirst(lastIndex)
        guard let index = readableBytesView.firstIndex(of: delimiter2) else {
            lastIndex = buffer.readableBytes
            return .needMoreData
        }
        guard readableBytesView[index - 1] == delimiter1 else {
            return .needMoreData
        }

        // slice the buffer
        let length = index - buffer.readerIndex - 1
        let slice = buffer.readSlice(length: length)!
        buffer.moveReaderIndex(forwardBy: 2)
        lastIndex = 0
        // call next handler
        context.fireChannelRead(wrapInboundOut(slice))
        return .continue
    }

    public func decodeLast(
        context: ChannelHandlerContext,
        buffer: inout ByteBuffer,
        seenEOF _: Bool
    ) throws -> DecodingState {
        while try decode(context: context, buffer: &buffer) == .continue {}
        if buffer.readableBytes > buffer.readerIndex {
            throw CodecError.badFraming
        }
        return .needMoreData
    }

    // outbound
    public func encode(data: OutboundIn, out: inout ByteBuffer) throws {
        var payload = data
        // original data
        out.writeBuffer(&payload)
        // add delimiter
        out.writeBytes([delimiter1, delimiter2])
    }
}

// bytes to codable and back
internal final class CodableCodec<In, Out>: ChannelInboundHandler, ChannelOutboundHandler,
    RemovableChannelHandler where In: Decodable,
    Out: Encodable {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = In
    public typealias OutboundIn = Out
    public typealias OutboundOut = ByteBuffer

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let initComplete: InitCompleteCallback?

    public init(_ initComplete: InitCompleteCallback? = nil) {
        self.initComplete = initComplete
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)
        let data = buffer.readData(length: buffer.readableBytes)!
        do {
            SharedLogger.debug(
                "--> decoding \(String(decoding: data[data.startIndex ..< min(data.startIndex + 100, data.endIndex)], as: UTF8.self))"
            )
            let decodable = try decoder.decode(In.self, from: data)
            // call next handler
            context.fireChannelRead(wrapInboundOut(decodable))
        } catch let error as DecodingError {
            SharedLogger.error("DecodingError: \(error)")
            context.fireErrorCaught(CodecError.badJSON(error))
        } catch {
            SharedLogger.error("Read Error: \(error)")
            context.fireErrorCaught(error)
        }
    }

    // outbound
    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        do {
            let encodable = unwrapOutboundIn(data)
            let data = try encoder.encode(encodable)
            SharedLogger.debug("<-- encoding \(String(decoding: data, as: UTF8.self))")
            var buffer = context.channel.allocator.buffer(capacity: data.count)
            buffer.writeBytes(data)
            context.write(wrapOutboundOut(buffer), promise: promise)
        } catch let error as EncodingError {
            SharedLogger.error("EncodingError: \(error)")
            promise?.fail(CodecError.badJSON(error))
        } catch {
            SharedLogger.error("Write Error: \(error)")
            promise?.fail(error)
        }
    }

    public func handlerAdded(context: ChannelHandlerContext) {
        initComplete?(context)
    }
}

internal final class HalfCloseOnTimeout: ChannelInboundHandler {
    typealias InboundIn = Any

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        if event is IdleStateHandler.IdleStateEvent {
            // this will trigger ByteToMessageDecoder::decodeLast which is required to
            // recognize partial frames
            context.fireUserInboundEventTriggered(ChannelEvent.inputClosed)
        }
        context.fireUserInboundEventTriggered(event)
    }
}

internal enum CodecError: Error {
    case badFraming
    case badJSON(Error)
    case requestTooLarge
}
