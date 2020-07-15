//
//  ConditionalSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a value dependent on another
public struct ConditionalSchema: CodeModelProperty {
    public let properties: ConditionalSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ValueSchema]
}

public struct ConditionalSchemaProperties: CodeModelPropertyBundle {
    /// the primitive type for the conditional
    public let conditionalType: PrimitiveSchema

    /// the possible conditional values
    public let conditions: [ConditionalValue]
    
    /// the source value that drives the target value (property or parameter)
    public let sourceValue: Value
}
