//
//  OrSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an OR relationship between several schemas
public struct OrSchema: CodeModelProperty {
    public let properties: OrSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ComplexSchema]
}

public struct OrSchemaProperties: CodeModelPropertyBundle {
    /// the set of schemas that this schema is composed of. Every schema is optional
    public let anyOf: [ComplexSchema]
}
