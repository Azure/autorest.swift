//
//  OrSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an OR relationship between several schemas
public class OrSchema: ComplexSchema {
    /// the set of schemas that this schema is composed of. Every schema is optional
    public let anyOf: [ComplexSchema]
    
      enum CodingKeys: String, CodingKey {
    case anyOf
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    anyOf = try container.decode( [ComplexSchema].self, forKey: .anyOf)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(anyOf, forKey: .anyOf)
     try super.encode(to: encoder)
    }

}
