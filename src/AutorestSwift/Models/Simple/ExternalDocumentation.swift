//
//  ExternalDocumentation.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// A reference to external documentation
public struct ExternalDocumentation: Codable {
    public var description: String?

    /// A URI
    public var url: String

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
