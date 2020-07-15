//
//  Deprecation.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Represents  deprecation information for a given aspect
public struct Deprecation: Codable {
    /// The reason why this aspect
    public let message: String

    /// The api versions that this deprecation is applicable to.
    public let apiVersions: [ApiVersion]
}

