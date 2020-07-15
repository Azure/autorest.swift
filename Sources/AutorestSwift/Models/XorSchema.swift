//
//  XorSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an XOR relationship between several schemas
public struct XorSchema: Codable {
    /// the set of schemas that this must be one and only one of.
    public let oneOf: [Schema]

    // TODO: Apply allOf
    // public let allOf: [Schema]
}
