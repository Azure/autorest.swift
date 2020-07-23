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

/// a schema that represents a type with child properties.
public class ObjectSchema: ComplexSchema {
    /// the property of the polymorphic descriminator for this type, if there is one
    public let discriminator: Discriminator?

    /// maximum number of properties permitted
    public let maxProperties: Int?

    /// minimum number of properties permitted
    public let minProperties: Int?

    public let parents: Relations?

    public let children: Relations?

    public let discriminatorValue: String?

    // MARK: allOf: Schema Usage

    public let usage: [SchemaContext]

    /// Known media types in which this schema can be serialized
    public let serializationFormats: [KnownMediaType]

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case discriminator, maxProperties, minProperties, parents, children, discriminatorValue, usage,
            serializationFormats
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        discriminator = try? container.decode(Discriminator.self, forKey: .discriminator)
        maxProperties = try? container.decode(Int.self, forKey: .maxProperties)
        minProperties = try? container.decode(Int.self, forKey: .minProperties)
        parents = try? container.decode(Relations.self, forKey: .parents)
        children = try? container.decode(Relations.self, forKey: .children)
        discriminatorValue = try? container.decode(String.self, forKey: .discriminatorValue)
        usage = try container.decode([SchemaContext].self, forKey: .usage)
        serializationFormats = try container.decode([KnownMediaType].self, forKey: .serializationFormats)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if discriminator != nil { try container.encode(discriminator, forKey: .discriminator) }
        if maxProperties != nil { try container.encode(maxProperties, forKey: .maxProperties) }
        if minProperties != nil { try container.encode(minProperties, forKey: .minProperties) }
        if parents != nil { try container.encode(parents, forKey: .parents) }
        if children != nil { try container.encode(children, forKey: .children)
        }
        if discriminatorValue != nil { try container.encode(discriminatorValue, forKey: .discriminatorValue) }
        try container.encode(usage, forKey: .usage)
        try container.encode(serializationFormats, forKey: .serializationFormats)

        try super.encode(to: encoder)
    }
}

extension ObjectSchema: Stencilable {
    func generateSnippet() throws -> String {
        return try renderTemplate(filename: "Struct.stencil", dictionary: ["object": self])
    }
}
