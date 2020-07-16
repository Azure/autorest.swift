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
}
