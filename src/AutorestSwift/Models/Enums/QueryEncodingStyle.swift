//
//  QueryEncodingStyle.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public enum QueryEncodingStyle: String, Codable {
    case deepObject
    case form
    case pipeDelimited
    case spaceDelimited
}
