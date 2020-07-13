//
//  SchemaType.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Possible schema types that indicate the type of schema.
public enum SchemaType: String {
    case any
    case array
    case binary
    case boolean
    case byteArray = "byte-array"
    case char
    case choice
    case conditional
    case constant
    case credential
    case date
    case dateTime = "date-time"
    case dictionary
    case duration
    case flag
    case group
    case integer
    case not
    case number
    case object
    case odataQuery = "odata-query"
    case or
    case sealedChoice = "sealed-choice"
    case sealedConditional = "sealed-conditional"
    case string
    case time
    case unixTime = "unixtime"
    case unknown
    case uri
    case uuid
    case xor
}
