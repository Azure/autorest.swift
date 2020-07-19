//
//  ConstantSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias ConstantSchema = Compose<ConstantSchemaProperty, Schema>

/// a schema that represents a constant value
public struct ConstantSchemaProperty: Codable {
    /// the schema type of the constant value (ie, StringSchema, NumberSchema, etc)
    public let valueType: Schema

    /// the constant value
    public let value: ConstantValue
    
    public enum CodingKeys: String, CodingKey {
          case valueType, value
      }

    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let valueTypeschema = try? container.decode(StringSchema.self, forKey: .valueType) {
            valueType = valueTypeschema
        } else {
           valueType = try container.decode(Schema.self, forKey: .valueType)
        }
        
        value = try container.decode(ConstantValue.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(valueType, forKey: .valueType)
        try container.encode(value, forKey: .value)
    }
}
