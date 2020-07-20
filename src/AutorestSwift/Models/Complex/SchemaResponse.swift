//
//  SchemaResponse.swift
//
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

/// a response that should be deserialized into a result of type(schema)
public struct SchemaResponse: ResponseProtocol {
    /// the content returned by the service for a given operation
    public var schema: SchemaProtocol

    /// indicates whether the response can be 'null'
    public var nullable: Bool?

    // MARK: ResponseProtocol

    /// per-language information for this aspect
    public var language: Languages

    /// per-protocol information for this aspect
    public var `protocol`: Protocols

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
