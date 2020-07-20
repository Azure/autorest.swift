//
//  Value.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Common base interface for properties, parameters and the like.
public class Value: Codable {
    /// the schema of this Value
    public var schema: Schema

    /// if the value is marked 'required'.
    public let required: Bool?

    /// can null be passed in instead
    public let nullable: Bool?

    /// the value that the remote will assume if this value is not present
    public let assumedValue: String?

    /// the value that the client should provide if the consumer doesn't provide one
    public let clientDefaultValue: String?

    /// a short description
    public let summary: String?

    /// API versions that this applies to. Undefined means all versions
    public let apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    public let deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public let origin: String?

    /// External Documentation Links
    public let externalDocs: ExternalDocumentation?

    /// Per-language information for this aspect
    public let language: Languages

    /// Per-protocol information for this aspect
    public let `protocol`: Protocols

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?
}
