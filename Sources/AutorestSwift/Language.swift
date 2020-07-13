//
//  Language.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// The bare-minimum fields for per-language metadata on a given aspect
public struct Language: CodeModelProperty {
    public let properties: LanguageProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct LanguageProperties: CodeModelPropertyBundle {
    /// name used in actual implementation
    public let name: String

    /// description text - describes this node.
    public let description: String
}
