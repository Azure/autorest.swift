//
//  ObjectSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a type with child properties.
public struct ObjectSchema: SchemaUsageProtocol, ComplexSchemaProtocol {
    /// the property of the polymorphic descriminator for this type, if there is one
    public var discriminator: Discriminator?

    /// the collection of properties that are in this object
    public var properties: [PropertyProtocol]?

    /// maximum number of properties permitted
    public var maxProperties: Int?

    /// minimum number of properties permitted
    public var minProperties: Int?

    public var parents: Relations?

    public var children: Relations?

    public var discriminatorValue: String

    // MARK: SchemaUsageProtocol

    /// contexts in which the schema is used
    public var usage: [SchemaContext]

    /// Known media types in which this schema can be serialized
    public var serializationFormats: [KnownMediaType]

    // MARK: ComplexSchemaProtocol

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
