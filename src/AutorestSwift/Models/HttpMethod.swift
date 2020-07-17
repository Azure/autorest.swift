//
//  SchemaContext.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public enum HttpMethod: String, Codable {
    case delete
    case get
    case head
    case options
    case patch
    case post
    case put
    case trace
}
