//
//  GroupProperty.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct GroupProperty: PropertyProtocol {
    public var originalParameter: [ParameterProtocol]

    // MARK: PropertyProtocol

    // if the property is marked read-only (ie, not intended to be sent to the service)
    public var readOnly: Bool?

    // the wire name of this property
    public var serializedName: String

    // when a property is flattened, the property will be the set of serialized names to get to that target property.\n\nIf flattenedName is present, then this property is a flattened property.\n\n(ie, ['properties','name'] )
    public var flattenedNames: [String]?

    // if this property is used as a discriminator for a polymorphic type
    public var isDiscriminator: Bool?

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
