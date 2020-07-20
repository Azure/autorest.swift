//
//  CredentialSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a credential value
public struct CredentialSchema: PrimitiveSchemaProtocol {
    
    /// the maximum length of the string
    public var maxLength: Int? = nil

    /// the minimum length of the string
    public var minLength: Int? = nil

    /// a regular expression that the string must be validated against
    public var pattern: String? = nil

    // MARK: SchemaProtocol

    /// Per-language information for Schema
    public var language: Languages

    /// The schema type
    public var type: AllSchemaTypes

    /// A short description
    public var summary: String?

    /// Example information
    public var example: String?

    /// If the value isn't sent on the wire, the service will assume this
    public var defaultValue: String?

    /// Per-serialization information for this Schema
    public var serialization: SerializationFormats?

    /// API versions that this applies to. Undefined means all versions
    public var apiVersions: [ApiVersion]?

    /// Deprecation information -- ie, when this aspect doesn't apply and why
    public var deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public var origin: String?

    /// External Documentation Links
    public var externalDocs: ExternalDocumentation?

    /// Per-protocol information for this aspect
    public var `protocol`: Protocols

    public var properties: [PropertyProtocol]?

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
