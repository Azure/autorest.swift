//
//  HttpMethod.swift
//  
//
//  Created by Travis Prescott on 7/17/20.
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
