//
//  ConstantValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a container for the actual constant value
public class ConstantValue: Codable {
    /// per-language information for this value
    public let language: Language?

    /// the actual constant value to use
    public let value: String

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case language, value, extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try? container.decode(Language?.self, forKey: .language)
        value = try container.decode(String.self, forKey: .value)
        extensions = try? container.decode([String: Bool].self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if language != nil { try? container.encode(language, forKey: .language) }
        try container.encode(value, forKey: .value)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }
}
