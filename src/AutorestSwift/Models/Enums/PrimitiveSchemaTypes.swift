//
//  PrimitiveSchemaTypes.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public enum PrimitiveSchemaTypes: String, Codable {
    case boolean
    case char
    case credential
    case date
    case dateTime = "date-time"
    case duration
    case integer
    case number
    case string
    case time
    case unixTime = "unixtime"
    case uri
    case uuid
}
