//
//  ExternalDocumentation.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// A reference to external documentation
public class ExternalDocumentation: Codable {
    public let description: String?

    /// A URI
    public let url: String

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?

    enum CodingKeys: String, CodingKey {
        case description, url, extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try? container.decode(String?.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        extensions = try? container.decode([String: Bool].self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if description != nil { try? container.encode(description, forKey: .description) }
        try container.encode(url, forKey: .url)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }
}
