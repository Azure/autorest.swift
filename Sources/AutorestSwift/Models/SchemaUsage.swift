//
//  SchemaUsage.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TODO: Revisit adding GroupSchemaAllOf, ObjectSchemaAllOf protocol to Schema after clarificaiton with Azure Engineering team.
public struct SchemaUsage: Codable, ObjectSchemaAllOf, GroupSchemaAllOf {
    /// contexts in which the schema is used
    public let usage: [SchemaContext]

    /// Known media types in which this schema can be serialized
    public let serializationFormats: [KnownMediaType]
}

