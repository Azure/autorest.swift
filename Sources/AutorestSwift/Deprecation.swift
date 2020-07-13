//
//  Deprecation.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Represents  deprecation information for a given aspect
public struct Deprecation: CodeModelProperty {
    public let properties: DeprecationProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct DeprecationProperties: CodeModelPropertyBundle {
    /// The reason why this aspect
    public let message: String

    /// The api versions that this deprecation is applicable to.
    public let apiVersions: [ApiVersion]
}
