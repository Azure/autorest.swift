//
//  LanguageShortcut.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

protocol LanguageShortcut {
    var language: Languages { get set }

    var name: String { get }

    var description: String { get }

    var summary: String? { get }

    var serializedName: String? { get }

    var namespace: String? { get }
}

extension LanguageShortcut {
    var name: String {
        return language.swift.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var description: String {
        return language.swift.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var summary: String? {
        return language.swift.summary?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var serializedName: String? {
        return language.swift.serializedName?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var namespace: String? {
        return language.swift.namespace?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

protocol OptionalLanguageShortcut {
    var language: Languages? { get set }

    var name: String? { get }

    var description: String? { get }

    var summary: String? { get }

    var serializedName: String? { get }

    var namespace: String? { get }
}

extension OptionalLanguageShortcut {
    var name: String? {
        return language?.swift.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var description: String? {
        return language?.swift.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var summary: String? {
        return language?.swift.summary?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var serializedName: String? {
        return language?.swift.serializedName?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var namespace: String? {
        return language?.swift.namespace?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
