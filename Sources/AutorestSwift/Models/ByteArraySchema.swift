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

/// a schema that represents a ByteArray value
public struct ByteArraySchema: Codable {
    /// date-time format
    public let format: ByteArrayFormat

    // TODO: Apply allOf
    // public let allOf: [ValueSchema]
}
