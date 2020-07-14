//
//  DateTimeSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema that represents a DateTime value
public struct DateTimeSchema: CodeModelProperty {
    public let properties: DateTimeSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [PrimitiveSchema]
}

public enum DateTimeFormat: String {
    case date_time = "date-time"
    case date_time_rfc1123 = "date-time-rfc1123"
}

public struct DateTimeSchemaProperties: CodeModelPropertyBundle {
    /// date-time format
    public let format: DateTimeFormat
}
