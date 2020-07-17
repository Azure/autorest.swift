//
//  ParameterLocation.swift
//
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

/// the location that this parameter is placed in the http request
public enum ParameterLocation: String, Codable {
    case body
    case cookie
    case header
    case none
    case path
    case query
    case uri
    case virtual
}
