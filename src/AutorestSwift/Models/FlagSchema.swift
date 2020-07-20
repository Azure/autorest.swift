//
//  FlagSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public class FlagSchema: ValueSchema {
    /// the possible choices for in the set
    public let choices: [FlagValue]

    enum CodingKeys: String, CodingKey {
        case choices
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        choices = try container.decode([FlagValue].self, forKey: .choices)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(choices, forKey: .choices)
        try super.encode(to: encoder)
    }
}
