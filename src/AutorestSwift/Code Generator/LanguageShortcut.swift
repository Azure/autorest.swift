// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

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
