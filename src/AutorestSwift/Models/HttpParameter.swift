//
//  HttpParameter.swift
//
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

typealias HttpParameter = Protocol<HttpParameterProperties>

/// extended metadata for HTTP operation parameters
public class HttpParameterProperties: Codable {
    /// the location that this parameter is placed in the http request
    public let `in`: ParameterLocation

    /// the Serialization Style used for the parameter
    public let style: SerializationStyle?

    /// when set, 'form' style parameters generate separate parameters for each value of an array
    public let explode: Bool?

    /// when set, this indicates that the content of the parameter should not be subject to URI encoding rules
    public let skipUriEncoding: Bool?
}
