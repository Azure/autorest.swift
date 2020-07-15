//
//  ChoiceValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an individual choice in a ChoiceSchema
public struct ChoiceValue: CodeModelProperty {
    public let properties: ChoiceValueProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public enum StringOrNumberOrBoolean {
    case string(String)
    case int(Int)
    case bool(Bool)
}

public struct ChoiceValueProperties: CodeModelPropertyBundle {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let value: StringOrNumberOrBoolean
    
    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
