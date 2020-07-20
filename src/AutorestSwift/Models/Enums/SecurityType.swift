//
//  SecurityType.swift
//  
//
//  Created by Travis Prescott on 7/19/20.
//

import Foundation

public enum SecurityType: String, Codable {
    case apiKey
    case http
    case oauth2
    case openIdConnect
}
