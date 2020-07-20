//
//  Value.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Common base interface for properties, parameters and the like.
public protocol ValueProtocol: Codable {

    /// the schema of this Value
    var schema: SchemaProtocol { get set }

    /// if the value is marked 'required'.
    var required: Bool? { get set }

    /// can null be passed in instead
    var nullable: Bool? { get set }

    /// the value that the remote will assume if this value is not present
    var assumedValue: String? { get set }

    /// the value that the client should provide if the consumer doesn't provide one
    var clientDefaultValue: String? { get set }

    /// a short description
    var summary: String? { get set }

    /// API versions that this applies to. Undefined means all versions
    var apiVersions: [ApiVersion]? { get set }

    /// deprecation information -- ie, when this aspect doesn't apply and why
    var deprecated: Deprecation? { get set }

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    var origin: String? { get set }

    /// External Documentation Links
    var externalDocs: ExternalDocumentation? { get set }

    /// Per-language information for this aspect
    var language: Languages { get set }

    /// Per-protocol information for this aspect
    var `protocol`: Protocols { get set }

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // var extensions: Dictionary<AnyHashable, Codable>? { get set }
}
