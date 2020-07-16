//
//  ArraySchema.swift
//  
//
//  Created by Travis Prescott on 7/13/20.
//

import Foundation

public typealias ArraySchema = Compose<ArraySchemaProperty, ValueSchema>

/// a Schema that represents and array of values
public struct ArraySchemaProperty: Codable {
    /// elementType of the array
    public let elementType: Schema

    /// maximum number of elements in the array
    public let maxItems: Int?

    /// minimum number of elements in the array
    public let minItems: Int?

    /// if the elements in the array should be unique
    public let uniqueItems: Bool?

    /// if elements in the array should be nullable
    public let nullableItems: Bool?
}
