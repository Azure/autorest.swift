//
//  Schema.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public class Schema: Codable {
    /// Per-language information for Schema
    public let language: Languages

    /// The schema type
    public let type: AllSchemaTypes

    /// A short description
    public let summary: String?

    /// Example information
    public let example: String?

    /// If the value isn't sent on the wire, the service will assume this
    public let defaultValue: String?

    /// Per-serialization information for this Schema
    public let serialization: SerializationFormats?

    /// API versions that this applies to. Undefined means all versions
    public let apiVersions: [ApiVersion]?

    /// Deprecation information -- ie, when this aspect doesn't apply and why
    public let deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public let origin: String?

    /// External Documentation Links
    public let externalDocs: ExternalDocumentation?

    /// Per-protocol information for this aspect
    public let `protocol`: Protocols

    public let properties: [Property]?

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?
}
