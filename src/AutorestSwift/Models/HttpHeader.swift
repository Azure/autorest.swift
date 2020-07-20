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
    public let extensions: [String: Bool]?
}
