//
//  ObjectSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TODO: Revisit this protocol after clarificaiton with Azure Engineering team.
public protocol ObjectSchemaAllOf {}

/// a schema that represents a type with child properties.
public struct ObjectSchema: Codable {
    /// the property of the polymorphic descriminator for this type, if there is one
    public let discriminator: Discriminator?

    /// the collection of properties that are in this object
    public let properties: [Property]?

    /// maximum number of properties permitted
    public let maxProperties: Int?

    /// minimum number of properties permitted
    public let minProperties: Int?

    public let parents: Relations?

    public let children: Relations?

    public let discriminatorValue: String?

    // TODO: Apply allOf
    // public let allOf: [ObjectSchemaAllOf]
}
