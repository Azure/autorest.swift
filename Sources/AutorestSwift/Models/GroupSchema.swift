//
//  GroupSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// TODO: Revisit this protocol after clarificaiton with Azure Engineering team.
public protocol GroupSchemaAllOf {}

public struct GroupSchema: Codable {
    public let properties: [GroupProperty]

    // TODO: Apply allOf
    // public let allOf: [GroupSchemaAllOf]
}
