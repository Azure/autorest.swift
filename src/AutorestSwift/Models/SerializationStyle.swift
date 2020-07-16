//
//  SerializationStyle.swift
//  
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

/// The Serialization Style used for the parameter. Describes how the parameter value will be serialized depending on the type of the parameter value
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
