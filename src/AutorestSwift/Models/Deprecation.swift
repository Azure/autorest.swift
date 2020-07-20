//
//  Deprecation.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Represents  deprecation information for a given aspect
public class Deprecation: Codable {
    /// The reason why this aspect
    public let message: String

    /// The api versions that this deprecation is applicable to.
    public let apiVersions: [ApiVersion]
     enum CodingKeys: String, CodingKey {
    case message, apiVersions
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    message = try container.decode( String.self, forKey: .message)
    apiVersions = try container.decode( [ApiVersion].self, forKey: .apiVersions)

    }
     public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(message, forKey: .message)
    try container.encode(apiVersions, forKey: .apiVersions)

    }
}
