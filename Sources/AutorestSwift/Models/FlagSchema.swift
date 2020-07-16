//
//  FlagSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias FlagSchema = Compose<FlagSchemaProperty, ValueSchema>

public struct FlagSchemaProperty: Codable {
    /// the possible choices for in the set
    public let choices: [FlagValue]
}
