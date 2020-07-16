//
//  License.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// License information
public struct License: Codable {
    /// the name of the license
    public let name: String

    /// a URI pointing to the full license text
    public let url: String?

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
