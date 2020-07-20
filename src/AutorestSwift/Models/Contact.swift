//
//  File.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Contact information
public class Contact: Codable {
    /// contact name
    public let name: String?

    /// a URI
    public let url: String?

    /// contact email
    public let email: String?

    /// additional metadata extensions dictionary
    public let extensions: [String: Bool]?
    
     enum CodingKeys: String, CodingKey {
    case name, url, email, extensions
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try? container.decode( String?.self, forKey: .name)
    url = try? container.decode( String?.self, forKey: .url)
    email = try? container.decode( String?.self, forKey: .email)
    extensions = try? container.decode([String: Bool].self, forKey: .extensions)

    }
     public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if name != nil { try? container.encode(name, forKey: .name)}
    if url != nil { try? container.encode(url, forKey: .url)}
    if email != nil { try? container.encode(email, forKey: .email)}
    if extensions != nil { try container.encode(extensions, forKey: .extensions) }

    }

}
