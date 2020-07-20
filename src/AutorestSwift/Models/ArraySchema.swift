//
//  ArraySchema.swift
//
//
//  Created by Travis Prescott on 7/13/20.
//

import Foundation

public class ArraySchema: Schema {
    /// elementType of the array
    public let elementType: Schema

    /// maximum number of elements in the array
    public let maxItems: Int?

    /// minimum number of elements in the array
    public let minItems: Int?

    /// if the elements in the array should be unique
    public let uniqueItems: Bool?

    /// if elements in the array should be nullable
    public let nullableItems: Bool?

    public enum CodingKeys: String, CodingKey {
        case elementType, maxItems, minItems, uniqueItems, nullableItems
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let objectSchema = try? container.decode(ObjectSchema.self, forKey: .elementType) {
            self.elementType = objectSchema
        } else {
            self.elementType = try container.decode(Schema.self, forKey: .elementType)
        }
        self.maxItems = try? container.decode(Int.self, forKey: .maxItems)
        self.minItems = try? container.decode(Int.self, forKey: .minItems)
        self.uniqueItems = try? container.decode(Bool.self, forKey: .uniqueItems)
        self.nullableItems = try? container.decode(Bool.self, forKey: .nullableItems)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(elementType, forKey: .elementType)
        if maxItems != nil { try container.encode(maxItems, forKey: .maxItems) }
        if minItems != nil { try container.encode(minItems, forKey: .minItems) }
        if uniqueItems != nil { try container.encode(uniqueItems, forKey: .uniqueItems) }
        if nullableItems != nil { try container.encode(nullableItems, forKey: .nullableItems) }

        try super.encode(to: encoder)
    }
}
