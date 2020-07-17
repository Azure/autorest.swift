//
//  HttpHeader.swift
//  
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

public struct HttpHeader: Codable {
    public let header: String
    public let schema: Schema
    // TODO: Not Codable
    // public let extensions: Dictionary<String, Codable>?
}
