//
//  Languages.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual language generators
public class Languages: Codable {
    public let `default`: Language

    // these properties we can set
    private var _swift: Language?

    public var swift: Language {
        get {
            if _swift == nil {
                _swift = Language(from: `default`)
            }
            return _swift!
        }
        set {
            if _swift == nil {
                _swift = Language(from: `default`)
            }
            _swift = newValue
        }
    }

    public var objectiveC: Language?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case `default`
        case _swift = "swift"
        case objectiveC
    }
}
