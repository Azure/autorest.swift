//
//  DictionarySchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias DictionarySchema = Compose<DictionarySchemaProperty, ComplexSchema>

/// a schema that represents a key-value collection
public struct DictionarySchemaProperty: Codable {
    /// the element type of the dictionary. (Keys are always strings)
    public let elementType: Schema

    /// if elements in the dictionary should be nullable
    public let nullableItems: Bool?
}
