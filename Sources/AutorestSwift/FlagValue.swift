//
//  FlagValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct FlagValue: CodeModelProperty {
    public let properties: FlagValueProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct FlagValueProperties: CodeModelPropertyBundle {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let value: Int
    
    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
