//
//  ConditionalSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias ConditionalSchema = Compose<ConditionalSchemaProperty, ValueSchema>

/// a schema that represents a value dependent on another
public struct ConditionalSchemaProperty: Codable {
    /// the primitive type for the conditional
    public let conditionalType: PrimitiveSchema

    /// the possible conditional values
    public let conditions: [ConditionalValue]

    /// the source value that drives the target value (property or parameter)
    public let sourceValue: Value
}
