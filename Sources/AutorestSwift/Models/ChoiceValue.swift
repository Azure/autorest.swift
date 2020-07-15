//
//  ChoiceValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

//public enum StringOrNumberOrBoolean: String, Codable {
//    case string(String)
//    case int(Int)
//    case bool(Bool)
//}

/// an individual choice in a ChoiceSchema
public struct ChoiceValue: Codable {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    // TODO: Resolve question about enum
    public let value: String // StringOrNumberOrBoolean

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
