//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Contact information
public struct Contact: CodeModelProperty {
    public let properties: ContactProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct ContactProperties: CodeModelPropertyBundle {
    /// contact name
    public let name: String?

    /// a URI
    public let url: String?

    /// contact email
    public let email: String?

    /// additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
