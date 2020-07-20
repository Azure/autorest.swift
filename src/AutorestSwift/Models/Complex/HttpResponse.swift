//
//  HttpResponse.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public class HttpResponse: ProtocolInterface {
    // the possible HTTP status codes that this response MUST match one of
    public let statusCodes: [StatusCode]

    // canonical response type (ie, 'json')
    public let knownMediaType: KnownMediaType?

    // content returned by the service in the HTTP headers
    public let mediaTypes: [String]?

    // content returned by the service in the HTTP headers
    public let headers: [HttpHeader]?

    // sets of HTTP headers grouped together into a single schema
    public let headerGroups: [GroupSchema]?
}
