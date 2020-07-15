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
    public let language: Language

    /// the actual value
    public let target: StringOrNumberOrBoolean
    
    /// the source value
    public let source: StringOrNumberOrBoolean
    
    // TODO: Not Codable
    /// Additional metadata extensions dictionary
    //public let extensions: Dictionary<AnyHashable, Codable>?
}
