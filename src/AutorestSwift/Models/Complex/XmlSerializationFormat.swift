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

public class XmlSerializationFormat: SerializationFormat {
    public let name: String?

    public let namespace: String?

    public let prefix: String?

    public let attribute: Bool

    public let wrapped: Bool

    enum CodingKeys: String, CodingKey {
        case name, namespace, prefix, attribute, wrapped
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(String?.self, forKey: .name)
        namespace = try? container.decode(String?.self, forKey: .namespace)
        prefix = try? container.decode(String?.self, forKey: .prefix)
        attribute = try container.decode(Bool.self, forKey: .attribute)
        wrapped = try container.decode(Bool.self, forKey: .wrapped)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if name != nil { try? container.encode(name, forKey: .name) }
        if namespace != nil { try? container.encode(namespace, forKey: .namespace) }
        if prefix != nil { try? container.encode(prefix, forKey: .prefix) }
        try container.encode(attribute, forKey: .attribute)
        try container.encode(wrapped, forKey: .wrapped)
        try super.encode(to: encoder)
    }
}
