//
//  GroupSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct GroupSchema: Codable {
    public let properties: [GroupProperty]

    // TODO: Apply allOf
    //public let allOf: [GroupSchemaAllOf]
}
