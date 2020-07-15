//
//  OrSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an OR relationship between several schemas
public struct OrSchema: Codable {
    /// the set of schemas that this schema is composed of. Every schema is optional
    public let anyOf: [ComplexSchema]

    // TODO: Apply allOf
    //public let allOf: [ComplexSchema]
}
