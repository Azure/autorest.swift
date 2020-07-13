//
//  Security.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// The security information for the API surface
public struct Security: CodeModelProperty {
    public let properties: SecurityProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct SecurityProperties: CodeModelPropertyBundle {
    /// indicates that the API surface requires authentication
    public let authenticationRequired: Bool
}
