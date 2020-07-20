//
//  HttpRequestProtocol.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public protocol HttpRequestProtocol: ProtocolProtocol {
    /// A relative path to an individual endpoint. \n\nThe field name MUST begin with a slash. \nThe path is appended (no relative URL resolution) to the expanded URL from the Server Object's url field in order to construct the full URL. \nPath templating is allowed. \n\nWhen matching URLs, concrete (non-templated) paths would be matched before their templated counterparts.
    var path: String { get set }

    /// the base URI template for the operation. This will be a template that has Uri parameters to craft the base url to use.
    var uri: String { get set }

    // the HTTP Method used to process this operation
    var method: HttpMethod { get set }
}
