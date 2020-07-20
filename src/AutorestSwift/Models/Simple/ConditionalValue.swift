//
//  ConditionalValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// an individual value in a ConditionalSchema
public struct ConditionalValue: Codable {
    /// per-language information for this value
    public var language: Language

    /// the actual value
    // TODO: Resolve issue with enum
    public var target: String // StringOrNumberOrBoolean

    /// the source value
    // TODO: Resolve issue with enum
    public var source: String // StringOrNumberOrBoolean

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
