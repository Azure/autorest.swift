//
//  HttpHeader.swift
//
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

public struct HttpHeader: Codable {
    public var header: String
    public var schema: SchemaProtocol
    // TODO: Not Codable
    // public var extensions: Dictionary<String, Codable>?
}
