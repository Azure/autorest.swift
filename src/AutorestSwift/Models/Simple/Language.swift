//
//  Language.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// The bare-minimum fields for per-language metadata on a given aspect
public class Language: Codable {
    /// name used in actual implementation
    public var name: String

    /// description text - describes this node.
    public var description: String

    public var summary: String?

    public var serializedName: String?

    public var namespace: String?

    // MARK: Initializers

    public init(from original: Language) {
        self.name = original.name
        self.description = original.description
        self.summary = original.summary
        self.serializedName = original.serializedName
        self.namespace = original.namespace
    }
}
