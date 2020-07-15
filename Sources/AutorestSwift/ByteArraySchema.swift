//
//  ByteArraySchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a ByteArray value
public struct ByteArraySchema: CodeModelProperty {
    public let properties: ByteArraySchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [ValueSchema]
}

public enum ByteArrayFormat: String {
    case base64url
    case byte
}

public struct ByteArraySchemaProperties: CodeModelPropertyBundle {
    /// date-time format
    public let format: ByteArrayFormat
}
