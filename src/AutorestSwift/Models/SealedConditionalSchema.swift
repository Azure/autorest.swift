//
//  SealedConditionalSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a value dependent on another (not overridable)
public class SealedConditionalSchema: ValueSchema {
    /// the primitive type for the conditional
    public let conditionalType: PrimitiveSchema

    /// the possible conditional values
    public let conditions: [ConditionalValue]

    /// the source value that drives the target value
    public let sourceValue: [Value]
    
     enum CodingKeys: String, CodingKey {
    case conditionalType, conditions, sourceValue
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    conditionalType = try container.decode( PrimitiveSchema.self, forKey: .conditionalType)
    conditions = try container.decode( [ConditionalValue].self, forKey: .conditions)
    sourceValue = try container.decode( [Value].self, forKey: .sourceValue)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(conditionalType, forKey: .conditionalType)
    try container.encode(conditions, forKey: .conditions)
    try container.encode(sourceValue, forKey: .sourceValue)
     try super.encode(to: encoder)
    }
}
