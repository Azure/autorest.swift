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

    var name: String { get set }

    var description: String { get set }

    var summary: String? { get set }

    var serializedName: String? { get set }

    var namespace: String? { get set }
}

extension LanguageShortcut {
    var name: String {
        get {
            return language.swift.name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language.swift.name = newValue
        }
    }

    var description: String {
        get {
            return language.swift.description.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language.swift.description = newValue
        }
    }

    var summary: String? {
        get {
            return language.swift.summary?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language.swift.summary = newValue
        }
    }

    var serializedName: String? {
        get {
            return language.swift.serializedName?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language.swift.serializedName = newValue
        }
    }

    var namespace: String? {
        get {
            return language.swift.namespace?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language.swift.namespace = newValue
        }
    }
}

protocol OptionalLanguageShortcut {
    var language: Languages? { get set }

    var name: String? { get set }

    var description: String? { get set }

    var summary: String? { get set }

    var serializedName: String? { get set }

    var namespace: String? { get set }
}

extension OptionalLanguageShortcut {
    var name: String? {
        get {
            return language?.swift.name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            if let val = newValue {
                language?.swift.name = val
            }
        }
    }

    var description: String? {
        get {
            return language?.swift.description.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            if let val = newValue {
                language?.swift.description = val
            }
        }
    }

    var summary: String? {
        get {
            return language?.swift.summary?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language?.swift.summary = newValue
        }
    }

    var serializedName: String? {
        get {
            return language?.swift.serializedName?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language?.swift.serializedName = newValue
        }
    }

    var namespace: String? {
        get {
            return language?.swift.namespace?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        set {
            language?.swift.namespace = newValue
        }
    }
}
