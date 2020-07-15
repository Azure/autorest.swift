//
//  ComplexSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// schema types that can be objects
public struct ComplexSchema: Codable, Hashable {

    // TODO: Apply allOf
    // public let allOf: [Schema]
    
    public func hash(into hasher: inout Hasher) {
        // TODO: add allOf to hash value
        // hasher.combine(allOf)
    }
}
