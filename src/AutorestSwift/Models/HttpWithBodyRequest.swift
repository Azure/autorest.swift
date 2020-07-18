//
//  HttpWithBodyRequest.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public struct HttpWithBodyRequest: ProtocolInterface {
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

    // MARK: allOf HttpRequest

    /// A relative path to an individual endpoint. \n\nThe field name MUST begin with a slash. \nThe path is appended (no relative URL resolution) to the expanded URL from the Server Object's url field in order to construct the full URL. \nPath templating is allowed. \n\nWhen matching URLs, concrete (non-templated) paths would be matched before their templated counterparts.
    public let path: String

    /// the base URI template for the operation. This will be a template that has Uri parameters to craft the base url to use.
    public let uri: String

    // the HTTP Method used to process this operation
    public let method: HttpMethod
}
