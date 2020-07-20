//
//  NumberSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a Number value
public class NumberSchema: PrimitiveSchema {
    /// precision (# of bits?) of the number
    public let precision: Int

    /// if present, the number must be an exact multiple of this value
    public let multipleOf: Int?

    /// if present, the value must be lower than or equal to this (unless exclusiveMaximum is true)
    public let maximum: Int?

    /// if present, the value must be lower than maximum
    public let exclusiveMaximum: Bool?

    /// if present, the value must be highter than or equal to this (unless exclusiveMinimum is true)
    public let minimum: Int?

    /// if present, the value must be higher than minimum
    public let exclusiveMinimum: Bool?

    // MARK: Codable

    public enum CodingKeys: String, CodingKey {
        case precision, multipleOf, maximum, exclusiveMaximum, minimum, exclusiveMinimum
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        precision = try container.decode(Int.self, forKey: .precision)
        multipleOf = try? container.decode(Int.self, forKey: .multipleOf)
        maximum = try? container.decode(Int.self, forKey: .maximum)
        exclusiveMaximum = try? container.decode(
            Bool.self,
            forKey:
            .exclusiveMaximum
        )

        minimum = try? container.decode(Int.self, forKey: .minimum)
        exclusiveMinimum = try? container.decode(Bool.self, forKey: .exclusiveMinimum)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(precision, forKey: .precision)
        if multipleOf != nil { try container.encode(multipleOf, forKey: .multipleOf) }
        if maximum != nil { try container.encode(maximum, forKey: .maximum) }
        if exclusiveMaximum != nil { try container.encode(exclusiveMaximum, forKey: .exclusiveMaximum) }
        if minimum != nil { try container.encode(minimum, forKey: .minimum) }
        if exclusiveMinimum != nil { try container.encode(exclusiveMinimum, forKey: .exclusiveMinimum) }

        try super.encode(to: encoder)
    }
}
