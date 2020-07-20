//
//  SchemaUsage.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public class SchemaUsage: Codable {
    /// contexts in which the schema is used
    public let usage: [SchemaContext]

    /// Known media types in which this schema can be serialized
    public let serializationFormats: [KnownMediaType]
}
