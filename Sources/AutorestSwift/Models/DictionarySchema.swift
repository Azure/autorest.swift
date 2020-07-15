//
//  DictionarySchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a key-value collection
public struct DictionarySchema: Codable {
    /// the element type of the dictionary. (Keys are always strings)
    public let elementType: Schema

    /// if elements in the dictionary should be nullable
    public let nullableItems: Bool?

    // TODO: Apply allOf
    // public let allOf: [ComplexSchema]
}
