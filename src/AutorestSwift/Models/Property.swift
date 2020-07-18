//
//  Property.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// a property is a child value in an object
public struct Property: Codable {
    // if the property is marked read-only (ie, not intended to be sent to the service)
    public let readOnly: Bool?

    // the wire name of this property
    public let serializedName: String

    // when a property is flattened, the property will be the set of serialized names to get to that target property.\n\nIf flattenedName is present, then this property is a flattened property.\n\n(ie, ['properties','name'] )
    public let flattenedNames: [String]?

    // if this property is used as a discriminator for a polymorphic type
    public let isDiscriminator: Bool?

    // MARK: allOf Value

    /// the schema of this Value
    public let schema: SchemaInterface

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

    public enum CodingKeys: String, CodingKey {
        case readOnly, serializedName, flattenedNames, isDiscriminator, schema, required, nullable, assumedValue,
            clientDefaultValue,
            summary, apiVersions, deprecated, origin, externalDocs, language, `protocol`
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let arrayschema = try? container.decode(ArraySchema.self, forKey: .schema) {
            schema = arrayschema;
        } else {
            schema = try container.decode(Schema.self, forKey: .schema)
        }

        self.readOnly = try? container.decode(Bool.self, forKey: .readOnly)
        self.serializedName = try container.decode(String.self, forKey: .serializedName)
        self.flattenedNames = try? container.decode([String].self, forKey: .flattenedNames)
        self.isDiscriminator = try? container.decode(Bool.self, forKey: .isDiscriminator)
        self.required = try? container.decode(Bool.self, forKey: .required)
        self.nullable = try? container.decode(Bool.self, forKey: .nullable)
        self.assumedValue = try? container.decode(String.self, forKey: .assumedValue)
        self.clientDefaultValue = try? container.decode(String.self, forKey: .clientDefaultValue)
        self.summary = try? container.decode(String.self, forKey: .summary)
        self.apiVersions = try? container.decode([ApiVersion].self, forKey: .apiVersions)
        self.deprecated = try? container.decode(Deprecation.self, forKey: .deprecated)
        self.origin = try? container.decode(String.self, forKey: .origin)
        self.externalDocs = try? container.decode(ExternalDocumentation.self, forKey: .externalDocs)
        self.language = try container.decode(Languages.self, forKey: .language)
        self.protocol = try container.decode(Protocols.self, forKey: .protocol)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if schema is ArraySchema {
            try container.encode(schema as? ArraySchema, forKey: .schema)
        } else if schema is Schema {
            try container.encode(schema as? Schema, forKey: .schema)
        }

        if readOnly != nil { try container.encode(readOnly, forKey: .readOnly) }
        try container.encode(serializedName, forKey: .serializedName)
        if flattenedNames != nil { try container.encode(flattenedNames, forKey: .flattenedNames) }
        if isDiscriminator != nil { try container.encode(isDiscriminator, forKey: .isDiscriminator) }
        if required != nil { try container.encode(required, forKey: .required) }
        if nullable != nil { try container.encode(nullable, forKey: .nullable) }
        if assumedValue != nil { try container.encode(assumedValue, forKey: .assumedValue) }
        if clientDefaultValue != nil { try container.encode(clientDefaultValue, forKey: .clientDefaultValue) }
        if summary != nil { try container.encode(summary, forKey: .summary) }
        if apiVersions != nil { try container.encode(apiVersions, forKey: .apiVersions) }
        if deprecated != nil { try container.encode(deprecated, forKey: .deprecated) }
        if origin != nil { try container.encode(origin, forKey: .origin) }
        if externalDocs != nil { try container.encode(externalDocs, forKey: .externalDocs) }
        try container.encode(language, forKey: .language)
        try container.encode(`protocol`, forKey: .protocol)
    }
}
