//
//  ArraySchema.swift
//
//
//  Created by Travis Prescott on 7/13/20.
//

import Foundation

public struct ArraySchema: ValueSchemaProtocol {

    /// elementType of the array
    public var elementType: SchemaProtocol

    /// maximum number of elements in the array
    public var maxItems: Int?

    /// minimum number of elements in the array
    public var minItems: Int?

    /// if the elements in the array should be unique
    public var uniqueItems: Bool?

    /// if elements in the array should be nullable
    public var nullableItems: Bool?

    // MARK: ValueSchema

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

    // MARK: Codable

//    public enum CodingKeys: String, CodingKey {
//        case elementType, maxItems, minItems, uniqueItems, nullableItems
//    }
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        self.elementType = try container.decode(SchemaProtocol.self, forKey: .elementType)
//        self.maxItems = try? container.decode(Int.self, forKey: .maxItems)
//        self.minItems = try? container.decode(Int.self, forKey: .minItems)
//        self.uniqueItems = try? container.decode(Bool.self, forKey: .uniqueItems)
//        self.nullableItems = try? container.decode(Bool.self, forKey: .nullableItems)
//
//        try super.init(from: decoder)
//    }
//
//    override public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(elementType, forKey: .elementType)
//        if maxItems != nil { try container.encode(maxItems, forKey: .maxItems) }
//        if minItems != nil { try container.encode(minItems, forKey: .minItems) }
//        if uniqueItems != nil { try container.encode(uniqueItems, forKey: .uniqueItems) }
//        if nullableItems != nil { try container.encode(nullableItems, forKey: .nullableItems) }
//
//        try super.encode(to: encoder)
//    }
}
