//
//  ChoiceSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a choice of several values (ie, an 'enum')
public struct ChoiceSchema: CodeModelProperty {
    public let properties: ChoiceSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ValueSchema]
}

public struct ChoiceSchemaProperties: CodeModelPropertyBundle {
    /// the primitive type for the choices
    public let choiceType: PrimitiveSchema

    /// the possible choices for in the set
    public let choices: [ChoiceValue]
}
