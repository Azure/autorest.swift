//
//  ArraySchema.swift
//  
//
//  Created by Travis Prescott on 7/13/20.
//

import Foundation

/// a Schema that represents and array of values
public struct ArraySchema: CodeModelProperty {
    public let properties: ArraySchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ValueSchema]
}

public struct ArraySchemaProperties: CodeModelPropertyBundle {
    /// elementType of the array
    public let elementType: Schema

    /// maximum number of elements in the array
    public let maxItems: Int?

    /// minimum number of elements in the array
    public let minItems: Int?

    /// if the elements in the array should be unique
    public let uniqueItems: Bool?

    /// if elements in the array should be nullable
    public let nullableItems: Bool?
}
