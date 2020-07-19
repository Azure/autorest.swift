//
//  HttpWithBodyRequest.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public class HttpWithBodyRequest: HttpRequest {
    // the possible HTTP status codes that this response MUST match one of.
    public let statusCodes: [HttpResponseStatusCode]?

    // canonical response type (ie, 'json')
    public let knownMediaType: KnownMediaType

    // content returned by the service in the HTTP headers
    public let mediaTypes: [String]

    // content returned by the service in the HTTP headers
    public let headers: [HttpHeader]?

    // sets of HTTP headers grouped together into a single schema
    public let headerGroups: [GroupSchema]?

    /*
        /// A relative path to an individual endpoint. \n\nThe field name MUST begin with a slash. \nThe path is appended (no relative URL resolution) to the expanded URL from the Server Object's url field in order to construct the full URL. \nPath templating is allowed. \n\nWhen matching URLs, concrete (non-templated) paths would be matched before their templated counterparts.
        public let path: String

        /// the base URI template for the operation. This will be a template that has Uri parameters to craft the base url to use.
        public let uri: String

        // the HTTP Method used to process this operation
        public let method: HttpMethod
     */

    public enum CodingKeys: String, CodingKey {
        case statusCodes, knownMediaType, mediaTypes, headers, headerGroups
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        statusCodes = try? container.decode([HttpResponseStatusCode].self, forKey: .statusCodes)
        knownMediaType = try container.decode(KnownMediaType.self, forKey: .knownMediaType)
        mediaTypes = try container.decode([String].self, forKey: .mediaTypes)
        headers = try? container.decode([HttpHeader].self, forKey: .headers)
        headerGroups = try? container.decode([GroupSchema].self, forKey: .headerGroups)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if statusCodes != nil { try container.encode(statusCodes, forKey: .statusCodes) }

        try container.encode(knownMediaType, forKey: .knownMediaType)
        try container.encode(mediaTypes, forKey: .mediaTypes)

        if headers != nil { try container.encode(headers, forKey: .headers) }
        if headerGroups != nil { try container.encode(headerGroups, forKey: .headerGroups) }

        try super.encode(to: encoder)
    }
}
