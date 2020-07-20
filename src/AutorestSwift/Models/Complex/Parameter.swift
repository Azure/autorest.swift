//
//  Parameter.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public struct Parameter: ValueProtocol {
    // MARK: ValueProtocol

    /// the schema of this Value
    public var schema: SchemaProtocol

    /// if the value is marked 'required'.
    public var required: Bool?

    /// can null be passed in instead
    public var nullable: Bool?

    /// the value that the remote will assume if this value is not present
    public var assumedValue: String?

    /// the value that the client should provide if the consumer doesn't provide one
    public var clientDefaultValue: String?

    /// a short description
    public var summary: String?

    /// API versions that this applies to. Undefined means all versions
    public var apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    public var deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public var origin: String?

    /// External Documentation Links
    public var externalDocs: ExternalDocumentation?

    /// Per-language information for this aspect
    public var language: Languages

    /// Per-protocol information for this aspect
    public var `protocol`: Protocols

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
