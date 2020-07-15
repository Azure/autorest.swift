//
//  FlagValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct FlagValue: Codable {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let value: Int
    
    // TODO: Not Codable
    /// Additional metadata extensions dictionary
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
