//
//  Languages.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual language generators
public struct Languages: Codable {
    public var `default`: Language

    public var python: Language?

    public var ruby: Language?

    public var go: Language?

    public var typescript: Language?

    public var javascript: Language?

    public var powershell: Language?

    public var java: Language?

    public var c: Language?

    public var cpp: Language?

    public var swift: Language?

    public var objectiveC: Language?

    public var sputnik: Language?
}
