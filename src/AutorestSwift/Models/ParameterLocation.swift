//
//  Parameter.swift
//
//
//  Created by Sam Cheung on 7/15/20.
//

import Foundation

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
