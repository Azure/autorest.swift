//
//  HttpParameter.swift
//
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

/// extended metadata for HTTP operation parameters
public struct HttpParameter: ProtocolProtocol {
    /// the location that this parameter is placed in the http request
    public var `in`: ParameterLocation

    /// the Serialization Style used for the parameter
    public var style: SerializationStyle?

    /// when set, 'form' style parameters generate separate parameters for each value of an array
    public var explode: Bool?

    /// when set, this indicates that the content of the parameter should not be subject to URI encoding rules
    public var skipUriEncoding: Bool?
}
