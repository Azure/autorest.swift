//
//  XorSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias XorSchema = Compose<XorSchemaProperty, Schema>

/// an XOR relationship between several schemas
public struct XorSchemaProperty: Codable {
    /// the set of schemas that this must be one and only one of.
    public let oneOf: [Schema]
}
