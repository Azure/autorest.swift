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
    public var name: String

    /// a URI pointing to the full license text
    public var url: String?

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
