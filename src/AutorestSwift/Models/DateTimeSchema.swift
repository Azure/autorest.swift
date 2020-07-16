//
//  DateTimeSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public enum DateTimeFormat: String, Codable {
    case dateTime = "date-time"
    case dateTimeRfc1123 = "date-time-rfc1123"
}

public typealias DateTimeSchema = Compose<DateTimeSchemaProperty, PrimitiveSchema>

/// a schema that represents a DateTime value
public struct DateTimeSchemaProperty: Codable {
    /// date-time format
    public let format: DateTimeFormat
}
