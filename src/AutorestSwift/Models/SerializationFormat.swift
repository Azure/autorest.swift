//
//  SerializationFormat.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public class SerializationFormat: Codable {
    public let extensions: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        extensions = try? container.decode([String: Bool].self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }
}
