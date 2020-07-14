//
//  ConstantValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a container for the actual constant value
public struct ConstantValue: CodeModelProperty {
    public let properties: ConstantValueProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct ConstantValueProperties: CodeModelPropertyBundle {
    /// per-language information for this value
    public let language: Language

    /// the actual constant value to use
    public let value: Any
    
    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
