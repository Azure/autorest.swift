//
//  ComplexSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// schema types that can be objects
public struct ComplexSchema: CodeModelProperty, ObjectSchemaAllOf {
    public let properties = [String: String]()

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [Schema]
}
