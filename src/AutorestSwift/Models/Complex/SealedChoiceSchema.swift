//
//  SealedChoiceSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a choice of several values (ie, an 'enum')
public class SealedChoiceSchema: ValueSchema {
    /// the primitive type for the choices
    public let choiceType: PrimitiveSchema

    /// the possible choices for in the set
    public let choices: [ChoiceValue]

    enum CodingKeys: String, CodingKey {
        case choiceType, choices
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        choiceType = try container.decode(PrimitiveSchema.self, forKey: .choiceType)
        choices = try container.decode([ChoiceValue].self, forKey: .choices)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(choiceType, forKey: .choiceType)
        try container.encode(choices, forKey: .choices)
        try super.encode(to: encoder)
    }
}
