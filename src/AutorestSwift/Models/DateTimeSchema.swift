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
public class DateTimeSchema: ValueSchema {
    /// date-time format
    public let format: DateTimeFormat

    public enum CodingKeys: String, CodingKey {
        case format
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        format = try container.decode(DateTimeFormat.self, forKey: .format)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(format, forKey: .format)

        try super.encode(to: encoder)
    }
}
