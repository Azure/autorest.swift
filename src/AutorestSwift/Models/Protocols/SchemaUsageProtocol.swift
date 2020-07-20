//
//  SchemaUsageProtocol.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public protocol SchemaUsageProtocol: Codable {
    /// contexts in which the schema is used
    var usage: [SchemaContext] { get set }

    /// Known media types in which this schema can be serialized
    var serializationFormats: [KnownMediaType] { get set }
}
