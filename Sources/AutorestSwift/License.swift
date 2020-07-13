//
//  License.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// License information
public struct License: CodeModelProperty {
    public let properties: LicenseProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct LicenseProperties: CodeModelPropertyBundle {
    /// the name of the license
    public let name: String

    /// a URI pointing to the full license text
    public let url: String?

    /// additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
