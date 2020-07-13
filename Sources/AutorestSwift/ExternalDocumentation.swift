//
//  ExternalDocumentation.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// A reference to external documentation
public struct ExternalDocumentation: CodeModelProperty {
    public let properties: ExternalDocumentationProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct ExternalDocumentationProperties: CodeModelPropertyBundle {
    public let description: String?

    /// A URI
    public let url: String

    /// Additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
