//
//  SchemaUsage.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TOOD: Revisit adding GroupSchemaAllOf, ObjectSchemaAllOf protocol to Schema after clarificaiton with Azure Engineering team.
public struct SchemaUsage: CodeModelProperty, ObjectSchemaAllOf, GroupSchemaAllOf {
    public let properties: SchemaUsageProperties
    
    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct SchemaUsageProperties: CodeModelPropertyBundle {
    /// contexts in which the schema is used
    public let usage: [SchemaContext]

    /// Known media types in which this schema can be serialized
    public let serializationFormats: [KnownMediaType]
}
