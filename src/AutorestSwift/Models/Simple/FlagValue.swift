//
//  FlagValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct FlagValue: Codable {
    /// per-language information for this value
    public var language: Language

    /// the actual value
    public var value: Int

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
