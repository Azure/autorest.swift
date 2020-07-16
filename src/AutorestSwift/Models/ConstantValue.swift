//
//  ConstantValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a container for the actual constant value
public struct ConstantValue: Codable {
    /// per-language information for this value
    public let language: Language?

    /// the actual constant value to use
    public let value: String

    /// Additional metadata extensions dictionary
    // TODO: Not Codable
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
