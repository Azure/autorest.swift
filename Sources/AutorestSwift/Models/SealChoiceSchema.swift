//
//  SealedChoiceSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation


public typealias SealedChoiceSchema = Compose<SealedChoiceSchemaProperty, ValueSchema>

/// a schema that represents a choice of several values (ie, an 'enum')
public struct SealedChoiceSchemaProperty: Codable {
    /// the primitive type for the choices
    public let choiceType: PrimitiveSchema

    /// the possible choices for in the set
    public let choices: [ChoiceValue]
}
