//
//  FlagSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct FlagSchema: CodeModelProperty {
    public let properties: FlagSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ValueSchema]
}

public struct FlagSchemaProperties: CodeModelPropertyBundle {
    /// the possible choices for in the set
    public let choices: [FlagValue]
}
