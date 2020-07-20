//
//  XorSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// public typealias XorSchema = Compose<XorSchemaProperty, Schema>

/// an XOR relationship between several schemas
public class XorSchema: Schema {
    /// the set of schemas that this must be one and only one of.
    public let oneOf: [Schema]

    enum CodingKeys: String, CodingKey {
        case oneOf
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        oneOf = try container.decode([Schema].self, forKey: .oneOf)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oneOf, forKey: .oneOf)
        try super.encode(to: encoder)
    }
}
