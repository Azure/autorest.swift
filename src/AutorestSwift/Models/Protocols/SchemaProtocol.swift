//
//  SchemaProtocol.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public protocol SchemaProtocol: Codable {
    /// Per-language information for Schema
    var language: Languages { get set }

    /// The schema type
    var type: AllSchemaTypes { get set }

    /// A short description
    var summary: String? { get set }

    /// Example information
    var example: String? { get set }

    /// If the value isn't sent on the wire, the service will assume this
    var defaultValue: String? { get set }

    /// Per-serialization information for this Schema
    var serialization: SerializationFormats? { get set }

    /// API versions that this applies to. Undefined means all versions
    var apiVersions: [ApiVersion]? { get set }

    /// Deprecation information -- ie, when this aspect doesn't apply and why
    var deprecated: Deprecation? { get set }

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    var origin: String? { get set }

    /// External Documentation Links
    var externalDocs: ExternalDocumentation? { get set }

    /// Per-protocol information for this aspect
    var `protocol`: Protocols { get set }

    var properties: [PropertyProtocol]? { get set }
    
    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // var extensions: Dictionary<AnyHashable, Codable>? { get set }
}
