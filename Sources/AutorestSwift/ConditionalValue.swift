//
//  ConditionalValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an individual value in a ConditionalSchema
public struct ConditionalValue: CodeModelProperty {
    public let properties: ConditionalValueProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct ConditionalValueProperties: CodeModelPropertyBundle {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let target: StringOrNumberOrBoolean
    
    /// the source value
    public let source: StringOrNumberOrBoolean
    
    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
