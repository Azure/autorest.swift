//
//  StringSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a string value
public class StringSchema: PrimitiveSchema {
    /// the maximum length of the string
    public let maxLength: Int?

    /// the minimum length of the string
    public let minLength: Int?

    /// a regular expression that the string must be validated against
    public let pattern: String?

    // MARK: Codable

     enum CodingKeys: String, CodingKey {
        case maxLength, minLength, pattern
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        maxLength = try? container.decode(Int.self, forKey: .maxLength)
        minLength = try? container.decode(Int.self, forKey: .minLength)
        pattern = try? container.decode(String.self, forKey: .pattern)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if maxLength != nil { try container.encode(maxLength, forKey: .maxLength) }
        if minLength != nil { try container.encode(minLength, forKey: .minLength) }
        if pattern != nil { try container.encode(pattern, forKey: .pattern) }

        try super.encode(to: encoder)
    }

}
