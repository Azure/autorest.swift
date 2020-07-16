//
//  ByteArraySchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public enum ByteArrayFormat: String, Codable {
    case base64url
    case byte
}

public typealias ByteArraySchema = Compose<ByteArraySchemaProperty, ValueSchema>

/// a schema that represents a ByteArray value
public struct ByteArraySchemaProperty: Codable {
    /// date-time format
    public let format: ByteArrayFormat
}
