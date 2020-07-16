//
//  UriSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias UriSchema = Compose<UriSchemaProperty, PrimitiveSchema>

/// a schema that represents a Uri value
public struct UriSchemaProperty: Codable {
    /// the maximum length of the string
    public let maxLength: Int?

    /// the minimum length of the string
    public let minLength: Int?

    /// a regular expression that the string must be validated against
    public let pattern: String?
}
