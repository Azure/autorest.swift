//
//  DictionarySchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a key-value collection
public class DictionarySchema: ComplexSchema {
    /// the element type of the dictionary. (Keys are always strings)
    public let elementType: Schema

    /// if elements in the dictionary should be nullable
    public let nullableItems: Bool?

    enum CodingKeys: String, CodingKey {
        case elementType, nullableItems
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        elementType = try container.decode(Schema.self, forKey: .elementType)
        nullableItems = try? container.decode(Bool?.self, forKey: .nullableItems)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(elementType, forKey: .elementType)
        if nullableItems != nil { try? container.encode(nullableItems, forKey: .nullableItems) }
        try super.encode(to: encoder)
    }
}
