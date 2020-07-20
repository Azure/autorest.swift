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
public class ByteArraySchema: ValueSchema {
    /// date-time format
    public let format: ByteArrayFormat

    enum CodingKeys: String, CodingKey {
        case format
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        format = try container.decode(ByteArrayFormat.self, forKey: .format)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(format, forKey: .format)
        try super.encode(to: encoder)
    }
}
