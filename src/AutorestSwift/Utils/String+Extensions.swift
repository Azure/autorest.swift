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

extension String {
    /// Returns a list of lowercased string components split on uppercase characters with
    /// acryonyms joined
    var splitAndJoinAcronyms: [String] {
        let value = replacingOccurrences(
            of: "([A-Z])",
            with: " $1",
            options: .regularExpression,
            range: range(of: self)
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .lowercased()

        let fineComponents = value.split(separator: " ").map { String($0) }
        var components = [String]()
        var index = 0

        // search for any acronyms that may be hidden in the string
        while index < fineComponents.count {
            let comp = fineComponents[index]
            if comp.count > 1 {
                components.append(comp)
                index += 1
            } else {
                // combine an acronym to a single component
                var acronym = comp
                var endex = index + 1
                while endex < fineComponents.count {
                    let curr = fineComponents[endex]
                    if curr.count == 1 {
                        acronym += curr
                        endex += 1
                        index += 1
                        continue
                    }
                    components.append(acronym)
                    index += 1
                    acronym = ""
                    break
                }
                if acronym != "" {
                    components.append(acronym)
                    index += 1
                    acronym = ""
                }
            }
        }
        return components
    }

    /// Converts a string into one with camel casing. Acronyms are forced to camel case as well.
    var toCamelCase: String {
        let components = splitAndJoinAcronyms
        var casedComponents = [String]()
        for (index, comp) in components.enumerated() {
            casedComponents.append(index == 0 ? comp : comp.capitalized)
        }
        let value = casedComponents.joined()
        return value
    }

    /// Converts a string into one with camel casing. Acronyms are forced to camel case as well.
    var toPascalCase: String {
        let components = splitAndJoinAcronyms
        let casedComponents = components.map { $0.capitalized }
        let value = casedComponents.joined()
        return value
    }
}
