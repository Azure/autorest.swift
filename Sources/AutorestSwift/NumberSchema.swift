//
//  NumberSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a Number value
public struct NumberSchema: CodeModelProperty {
    public let properties: NumberSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [PrimitiveSchema]
}

public struct NumberSchemaProperties: CodeModelPropertyBundle {
    /// precision (# of bits?) of the number
    public let precision: Int?

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

}
