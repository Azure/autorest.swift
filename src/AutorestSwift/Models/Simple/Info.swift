//
//  File.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Code model information
public struct Info: Codable {
    /// the title of this service
    public var title: String

    /// a text description of the service
    public var description: String?

    /// a URI to the terms of service specified to access the service
    public var termsOfService: String?

    /// contact information for the service
    public var contact: Contact?

    /// license information for the service
    public var license: License?

    /// external documentation
    public var externalDocs: ExternalDocumentation?

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
