//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Contact information
public struct Contact: Codable {
    /// contact name
    public let name: String?

    /// a URI
    public let url: String?

    /// contact email
    public let email: String?

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
