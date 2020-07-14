//
//  ComplexSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TOOD: Revisit adding ObjectSchemaAllOf protocol to Schema after clarificaiton with Azure Engineering team.
/// schema types that can be objects
public struct ComplexSchema: CodeModelProperty, Hashable, ObjectSchemaAllOf {
    public let properties = [String: String]()

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [Schema]

    // TODO: add allOf property in calculating hash value
    public func hash(into hasher: inout Hasher) {
        hasher.combine(additionalProperties)
    }

    // TODO: check allOf property in checking equality
    public static func ==(lhs: ComplexSchema, rhs: ComplexSchema) -> Bool {
        return lhs.properties.count == rhs.properties.count && lhs.defaultProperties.count == rhs.defaultProperties.count && lhs.additionalProperties == rhs.additionalProperties && lhs.properties.count == 0 && rhs.properties.count == 0 && lhs.additionalProperties == rhs.additionalProperties
    }
}
