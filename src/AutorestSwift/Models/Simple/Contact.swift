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
    public var name: String?

    /// a URI
    public var url: String?

    /// contact email
    public var email: String?

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
