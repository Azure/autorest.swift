//
//  ValueSchemaTypes.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public enum ValueSchemaTypes: String, Codable {
    case array
    case boolean
    case byteArray = "byte-array"
    case char
    case choice
    case conditional
    case credential
    case date
    case dateTime = "date-time"
    case duration
    case flag
    case integer
    case number
    case sealedChoice = "sealed-choice"
    case sealedConditional = "sealed-conditional"
    case string
    case time
    case unixTime = "unixtime"
    case uri
    case uuid
}
