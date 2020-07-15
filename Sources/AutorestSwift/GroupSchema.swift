//
//  GroupSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TOOD: Revisit this protocol after clarificaiton with Azure Engineering team.
public protocol GroupSchemaAllOf {}

public struct GroupSchema: CodeModelProperty {
    public let properties: GroupSchemaProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [GroupSchemaAllOf]
}

public struct GroupSchemaProperties: CodeModelPropertyBundle {
    public let properties: [GroupProperty]
}
