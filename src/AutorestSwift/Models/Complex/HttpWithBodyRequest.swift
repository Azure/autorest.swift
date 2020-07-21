//
//  HttpWithBodyRequest.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public class HttpWithBodyRequest: HttpRequest {
    // canonical response type (ie, 'json')
    public let knownMediaType: KnownMediaType

    // content returned by the service in the HTTP headers
    public let mediaTypes: [String]

    // content returned by the service in the HTTP headers
    public let headers: [HttpHeader]?

    // sets of HTTP headers grouped together into a single schema
    public let headerGroups: [GroupSchema]?

    enum CodingKeys: String, CodingKey {
        case knownMediaType, mediaTypes, headers, headerGroups
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        knownMediaType = try container.decode(KnownMediaType.self, forKey: .knownMediaType)
        mediaTypes = try container.decode([String].self, forKey: .mediaTypes)
        headers = try? container.decode([HttpHeader].self, forKey: .headers)
        headerGroups = try? container.decode([GroupSchema].self, forKey: .headerGroups)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(knownMediaType, forKey: .knownMediaType)
        try container.encode(mediaTypes, forKey: .mediaTypes)

        if headers != nil { try container.encode(headers, forKey: .headers) }
        if headerGroups != nil { try container.encode(headerGroups, forKey: .headerGroups) }

        try super.encode(to: encoder)
    }
}
