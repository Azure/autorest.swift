//
//  OrSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias OrSchema = Compose<OrSchemaProperty, ComplexSchema>

/// an OR relationship between several schemas
public struct OrSchemaProperty: Codable {
    /// the set of schemas that this schema is composed of. Every schema is optional
    public let anyOf: [ComplexSchema]
}
