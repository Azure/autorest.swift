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

/// a schema that represents a DateTime value
public struct DateTimeSchema: Codable {
    /// date-time format
    public let format: DateTimeFormat

    // TODO: Apply allOf
    // public let allOf: [PrimitiveSchema]
}
