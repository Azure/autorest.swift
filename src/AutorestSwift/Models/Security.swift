//
//  Security.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// The security information for the API surface
public struct Security: Codable {
    /// indicates that the API surface requires authentication
    public let authenticationRequired: Bool
}
