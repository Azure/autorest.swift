//
//  ChoiceValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// Represents  deprecation information for a given aspect
public struct ChoiceValue: CodeModelProperty {
    public let properties: ChoiceValueProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public enum ValueString: String {
    case string = "string"
    case number = "number"
    case boolean = "boolean"
}

public struct ChoiceValueProperties: CodeModelPropertyBundle {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let value: ValueString
    
    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
