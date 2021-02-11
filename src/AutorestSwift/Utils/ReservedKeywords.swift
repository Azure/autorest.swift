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

private let reservedTypes = [
    "Error": true,
    "Int": true,
    "String": true,
    "Bool": true,
    "Enum": true,
    "Array": true,
    "Date": true,
    "Self": true,
    "Any": true
]

private let reservedKeywords = [
    "associatedtype": true,
    "class": true,
    "deinit": true,
    "enum": true,
    "extension": true,
    "fileprivate": true,
    "func": true,
    "import": true,
    "init": true,
    "inout": true,
    "internal": true,
    "let": true,
    "open": true,
    "operator": true,
    "private": true,
    "protocol": true,
    "public": true,
    "static": true,
    "struct": true,
    "subscript": true,
    "typealias": true,
    "var": true,
    "break": true,
    "case": true,
    "continue": true,
    "default": true,
    "defer": true,
    "do": true,
    "else": true,
    "fallthrough": true,
    "for": true,
    "guard": true,
    "if": true,
    "in": true,
    "repeat": true,
    "return": true,
    "switch": true,
    "where": true,
    "while": true,
    "as": true,
    "catch": true,
    "false": true,
    "is": true,
    "nil": true,
    "rethrows": true,
    "super": true,
    "self": true,
    "throw": true,
    "throws": true,
    "true": true,
    "try": true
]

extension String {
    /// Returns `true` if the string corresponds to a reserved type
    var isReservedType: Bool {
        return reservedTypes[self] ?? false
    }

    /// Returns `true` if the string corresponds to a reserved Swift keyword
    var isReservedKeyword: Bool {
        return reservedKeywords[self] ?? false
    }
}
