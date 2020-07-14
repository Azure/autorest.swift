//
//  DictionarySchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a key-value collection
public struct DictionarySchema: CodeModelProperty {
    public let properties: DictionarySchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ComplexSchema]
}

public struct DictionarySchemaProperties: CodeModelPropertyBundle {
    /// the element type of the dictionary. (Keys are always strings)
    public let elementType: Schema
    
    /// if elements in the dictionary should be nullable
    public let nullableItems: Bool
}
