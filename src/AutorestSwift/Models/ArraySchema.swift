//
//  ArraySchema.swift
//
//
//  Created by Travis Prescott on 7/13/20.
//

import Foundation

public struct ArraySchema: SchemaInterface {
    /// elementType of the array
    public let elementType: Schema

    /// maximum number of elements in the array
    public let maxItems: Int?

    /// minimum number of elements in the array
    public let minItems: Int?

    /// if the elements in the array should be unique
    public let uniqueItems: Bool?

    /// if elements in the array should be nullable
    public let nullableItems: Bool?

    // MARK: allOf: ValueSchema, same as Schema

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
}
