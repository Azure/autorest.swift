//
//  ConditionalValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an individual value in a ConditionalSchema
public class ConditionalValue: Codable {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    // TODO: Resolve issue with enum
    public let target: String // StringOrNumberOrBoolean

    /// the source value
    // TODO: Resolve issue with enum
    public let source: String // StringOrNumberOrBoolean

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case language, target, source, extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decode(Language.self, forKey: .language)
        target = try container.decode(String.self, forKey: .target)
        source = try container.decode(String.self, forKey: .source)
        extensions = try? container.decode([String: Bool].self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(language, forKey: .language)
        try container.encode(target, forKey: .target)
        try container.encode(source, forKey: .source)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }
}
