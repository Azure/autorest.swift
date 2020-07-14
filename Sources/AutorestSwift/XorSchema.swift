//
//  XorSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an XOR relationship between several schemas
public struct XorSchema: CodeModelProperty {
    public let properties: XorSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [Schema]
}

public struct XorSchemaProperties: CodeModelPropertyBundle {
    /// the set of schemas that this must be one and only one of.
    public let oneOf: [Schema]
}
