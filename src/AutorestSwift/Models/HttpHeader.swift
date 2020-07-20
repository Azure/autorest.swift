//
//  HttpHeader.swift
//
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

public class HttpHeader: Codable {
    public let header: String
    public let schema: Schema
    public let extensions: [String: Bool]?
    
     enum CodingKeys: String, CodingKey {
    case header, schema, extensions
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    header = try container.decode( String.self, forKey: .header)
    schema = try container.decode( Schema.self, forKey: .schema)
    extensions = try? container.decode( [String: Bool].self, forKey: .extensions)
    }
     public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(header, forKey: .header)
    try container.encode(schema, forKey: .schema)
    try container.encode(extensions, forKey: .extensions)
    }
}
