//
//  Parameter.swift
//
//
//  Created by Sam Cheung on 7/15/20.
//

import Foundation

public enum SerializationStyle: String, Codable {
    case binary
    case deepObject
    case form
    case json
    case label
    case matrix
    case pipeDelimited
    case simple
    case spaceDelimited
    case tabDelimited
    case xml
}
