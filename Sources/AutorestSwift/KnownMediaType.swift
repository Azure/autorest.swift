//
//  KnownMediaType.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public enum KnownMediaType: String, Codable {
    case binary
    case form
    case json
    case multipart
    case text
    case unknown
    case xml
}
