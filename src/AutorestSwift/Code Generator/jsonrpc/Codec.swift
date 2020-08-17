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
            let framingHandler = ContentLengthHeaderFrameDecoder()
            let encoder1 = ContentLengthHeaderFrameEncoder() // JSONPosCodec()
            return addHandlers([
                ByteToMessageHandler(framingHandler),
                MessageToByteHandler(encoder1)
            ])
        case .brute:
            let framingHandler = BruteForceCodec<JSONResponse>()
            return addHandlers([
                ByteToMessageHandler(framingHandler),
                MessageToByteHandler(framingHandler)
            ])
        case .default:
            let framingHandler = NewlineEncoder()
            return addHandlers([
                ByteToMessageHandler(framingHandler),
                MessageToByteHandler(framingHandler)
            ])
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
    private let log: URL

    init() {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }

        self.log = documentsUrl.appendingPathComponent("autorest-swift.log")
    }

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
        try? "call next handler \(length)".appendLineToURL(fileURL: log)
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
            try? "CodecError.badFraming 1".appendLineToURL(fileURL: log)
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

// https://www.poplatek.fi/payments/jsonpos/transport
// JSON/RPC messages are framed with the following format (in the following byte-by-byte order):
// 8 bytes: ASCII lowercase hex-encoded length (LEN) of the actual JSON/RPC message (receiver MUST accept both uppercase and lowercase)
// 1 byte: a colon (":", 0x3a), not included in LEN
// LEN bytes: a JSON/RPC message, no leading or trailing whitespace
// 1 byte: a newline (0x0a), not included in LEN
internal final class JSONPosCodec: ByteToMessageDecoder, MessageToByteEncoder {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = ByteBuffer
    public typealias OutboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer

    private let newline = UInt8(ascii: "\n")
    private let colon = UInt8(ascii: ":")
    private let delimiter = UInt8(ascii: "\r")

    private let log: URL

    init() {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }

        self.log = documentsUrl.appendingPathComponent("autorest-swift.log")
    }

    // inbound
    public func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        guard buffer.readableBytes < maxPayload else {
            throw CodecError.requestTooLarge
        }
        guard buffer.readableBytes >= 10 else {
            return .needMoreData
        }

        let len = buffer.readableBytes
        // print(buffer.debugDescription)
        try? buffer.debugDescription.appendLineToURL(fileURL: log)

        let readableBytesView = buffer.readableBytesView
        // assuming we have the format Content-Length: <payload>\n
        let lengthView = readableBytesView.prefix(14) // contains Content-Length
        let fromColonView = readableBytesView.dropFirst(14) // contains :<payload>\n
        // let payloadView = fromColonView.dropFirst() // contains <payload>\n
        let hex1 = String(decoding: lengthView, as: Unicode.UTF8.self)
        let hex2 = String(decoding: fromColonView, as: Unicode.UTF8.self)
        // let hex = String(decoding: payloadView, as: Unicode.UTF8.self)

        guard let index = fromColonView.firstIndex(of: delimiter) else {
            try? "CodecError.badFraming 0 hex1=\(hex1) hex2=\(hex2)"
                .appendLineToURL(fileURL: log)
            throw CodecError.badFraming
        }

        let hexslice = buffer.getSlice(at: 15, length: index - 15)!

        let hexString: String = hexslice.getString(at: 0, length: index - 15)?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        try? "log \(hexslice) hexstring = \(hexString)".appendLineToURL(fileURL: log)

        let payloadView = fromColonView.dropFirst(index)

        guard let payloadSize = Int(hexString) else {
            try? "CodecError.badFraming 1 hex1=\(hex1) hex2=\(hex2)"
                .appendLineToURL(fileURL: log)
            throw CodecError.badFraming
        }
        /*  guard colon == fromColonView.first! else {
             try? "CodecError.badFraming 2".write(to: log7, atomically: true, encoding: .utf8)
             throw CodecError.badFraming
         }*/
        //  guard payloadView.count >= payloadSize + 1, newline == payloadView.last else {
        //      return .needMoreData
        //   }

        // slice the buffer
        //    assert(payloadView.startIndex == readableBytesView.startIndex + 9)
        try? "payloadSize \(payloadSize) payloadView.startIndex = \(payloadView.startIndex)"
            .appendLineToURL(fileURL: log)
        // len of 'Content-Length : " actual len
        let slice = buffer.getSlice(at: 22, length: payloadSize)!
        let sliceSTring: String = slice.getString(at: 0, length: payloadSize) ?? ""

        try? sliceSTring.appendLineToURL(fileURL: log)
        try? sliceSTring.appendLineToURL(fileURL: log)
        buffer.moveReaderIndex(to: payloadSize + 10)
        // try? slice.write(to: log5, atomically: true, encoding: .utf8)
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
            try? "CodecError.badFraming 3".appendLineToURL(fileURL: log)
            throw CodecError.badFraming
        }
        return .needMoreData
    }

    // outbound
    public func encode(data: OutboundIn, out: inout ByteBuffer) throws {
        var payload = data
        // length
        out.writeString(String(payload.readableBytes, radix: 16).leftPadding(toLength: 8, withPad: "0"))
        // colon
        out.writeBytes([colon])
        // payload
        out.writeBuffer(&payload)
        // newline
        out.writeBytes([newline])
    }
}

// no delimeter is provided, brute force try to decode the json
internal final class BruteForceCodec<T>: ByteToMessageDecoder, MessageToByteEncoder where T: Decodable {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = ByteBuffer
    public typealias OutboundIn = ByteBuffer
    public typealias OutboundOut = ByteBuffer

    private let last = UInt8(ascii: "}")

    private var lastIndex = 0

    public func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) throws -> DecodingState {
        guard buffer.readableBytes < maxPayload else {
            throw CodecError.requestTooLarge
        }

        // try to find a payload by looking for a json payload, first rough cut is looking for a trailing }
        let readableBytesView = buffer.readableBytesView.dropFirst(lastIndex)
        guard let _ = readableBytesView.firstIndex(of: last) else {
            lastIndex = buffer.readableBytes
            return .needMoreData
        }

        // try to confirm its a json payload by brute force decoding
        let length = buffer.readableBytes
        let data = buffer.getData(at: buffer.readerIndex, length: length)!
        do {
            _ = try JSONDecoder().decode(T.self, from: data)
        } catch is DecodingError {
            lastIndex = buffer.readableBytes
            return .needMoreData
        }

        // slice the buffer
        let slice = buffer.readSlice(length: length)!
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
        out.writeBuffer(&payload)
    }
}

// bytes to codable and back
internal final class CodableCodec<In, Out>: ChannelInboundHandler, ChannelOutboundHandler where In: Decodable,
    Out: Encodable {
    public typealias InboundIn = ByteBuffer
    public typealias InboundOut = In
    public typealias OutboundIn = Out
    public typealias OutboundOut = ByteBuffer

    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let log: URL

    init() {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }

        self.log = documentsUrl.appendingPathComponent("autorest-swift.log")
    }

    // inbound
    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buffer = unwrapInboundIn(data)
        let data = buffer.readData(length: buffer.readableBytes)!

        let str = String(decoding: data, as: UTF8.self)

        // try? str.appendLineToURL(fileURL: log)

        do {
            //   print(
            //       "--> decoding \(String(decoding: data[data.startIndex ..< min(data.startIndex + 100, data.endIndex)], as: //UTF8.self))"
            // )

            try? "--> decoding \(String(decoding: data[data.startIndex ..< min(data.startIndex + 100, data.endIndex)], as: UTF8.self))"
                .appendLineToURL(fileURL: log)
            let decodable = try decoder.decode(In.self, from: data)
            // call next handler
            context.fireChannelRead(wrapInboundOut(decodable))
        } catch let error as DecodingError {
            try? "\(error)".appendLineToURL(fileURL: log)
            context.fireErrorCaught(CodecError.badJSON(error))
        } catch {
            try? "\(error)".appendLineToURL(fileURL: log)
            context.fireErrorCaught(error)
        }
    }

    // outbound
    public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
        do {
            let encodable = unwrapOutboundIn(data)
            let data = try encoder.encode(encodable)
            // print("<-- encoding \(String(decoding: data, as: UTF8.self))")

            try? ("<-- encoding \(String(decoding: data, as: UTF8.self))").appendLineToURL(fileURL: log)

            var buffer = context.channel.allocator.buffer(capacity: data.count)
            buffer.writeBytes(data)
            context.write(wrapOutboundOut(buffer), promise: promise)
        } catch let error as EncodingError {
            promise?.fail(CodecError.badJSON(error))
        } catch {
            promise?.fail(error)
        }
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
