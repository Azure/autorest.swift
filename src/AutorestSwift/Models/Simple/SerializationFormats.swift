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

import Foundation

/// Custom extensible metadata for individual serialization formats
public class SerializationFormats: Codable {
    public let json: SerializationFormat?

    public let xml: XmlSerializationFormat?

    public let protobuf: SerializationFormat?

    public let binary: SerializationFormat?

    enum CodingKeys: String, CodingKey {
        case json, xml, protobuf, binary
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        json = try? container.decode(SerializationFormat?.self, forKey: .json)
        xml = try? container.decode(XmlSerializationFormat?.self, forKey: .xml)
        protobuf = try? container.decode(SerializationFormat?.self, forKey: .protobuf)
        binary = try? container.decode(SerializationFormat?.self, forKey: .binary)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if json != nil { try? container.encode(json, forKey: .json) }
        if xml != nil { try? container.encode(xml, forKey: .xml) }
        if protobuf != nil { try? container.encode(protobuf, forKey: .protobuf) }
        if binary != nil { try? container.encode(binary, forKey: .binary) }
    }
}
