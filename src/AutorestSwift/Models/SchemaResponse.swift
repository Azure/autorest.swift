//
//  SchemaResponse.swift
//
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

/// a response that should be deserialized into a result of type(schema)
public struct SchemaResponse: ResponseInterface {
    /// the content returned by the service for a given operation
    public let schema: Schema

    /// indicates whether the response can be 'null'
    public let nullable: Bool?

    // MARK: Response

    /// per-language information for this aspect
    public let language: Languages

    /// per-protocol information for this aspect
    public let `protocol`: Protocols
}
