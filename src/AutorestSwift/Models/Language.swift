//
//  Language.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// The bare-minimum fields for per-language metadata on a given aspect
public struct Language: Codable {
    /// name used in actual implementation
    public let name: String

    /// description text - describes this node.
    public let description: String

    public let summary: String?

    public let serializedName: String?

    public let namespace: String?
}
