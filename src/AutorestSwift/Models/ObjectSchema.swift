//
//  ObjectSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

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
