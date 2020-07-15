//
//  ConstantSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a constant value
public struct ConstantSchema: Codable {
    /// the schema type of the constant value (ie, StringSchema, NumberSchema, etc)
    public let valueType: Schema

    /// the constant value
    public let value: ConstantValue

    // TODO: Apply allOf
    // public let allOf: [Schema]
}
