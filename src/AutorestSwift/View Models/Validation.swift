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

struct Validation {
    /// the maximum length of the string
    let maxLength: Int?

    /// the minimum length of the string
    let minLength: Int?

    /// a regular expression that the string must be validated against
    let pattern: String?

    /// if present, the number must be an exact multiple of this value
    let multipleOf: Int?

    /// if present, the value must be lower than or equal to this (unless exclusiveMaximum is true)
    let maximum: Int?

    /// if present, the value must be lower than maximum
    let exclusiveMaximum: Bool?

    /// if present, the value must be highter than or equal to this (unless exclusiveMinimum is true)
    let minimum: Int?

    /// if present, the value must be higher than minimum
    let exclusiveMinimum: Bool?

    /// maximum number of elements in the array
    let maxItems: Int?

    /// minimum number of elements in the array
    let minItems: Int?

    /// if the elements in the array should be unique
    let uniqueItems: Bool?

    init?(
        maxLength: Int? = nil,
        minLength: Int? = nil,
        pattern: String? = nil,
        multipleOf: Int? = nil,
        maximum: Int? = nil,
        exclusiveMaximum: Bool? = nil,
        minimum: Int? = nil,
        exclusiveMinimum: Bool? = nil,
        maxItems: Int? = nil,
        minItems: Int? = nil,
        uniqueItems: Bool? = nil
    ) {
        var hasValidation = false
        for item in [
            maxLength,
            minLength,
            pattern,
            multipleOf,
            maximum,
            exclusiveMaximum,
            minimum,
            exclusiveMinimum,
            maxItems,
            minItems,
            uniqueItems
        ] as [Any?] where item != nil {
            hasValidation = true
            break
        }
        guard hasValidation else { return nil }
        self.maxLength = maxLength
        self.minLength = minLength
        self.pattern = pattern
        self.multipleOf = multipleOf
        self.maximum = maximum
        self.exclusiveMaximum = exclusiveMaximum
        self.minimum = minimum
        self.exclusiveMinimum = exclusiveMinimum
        self.maxItems = maxItems
        self.minItems = minItems
        self.uniqueItems = uniqueItems
    }

    init?(with schema: StringSchema) {
        self.init(
            maxLength: schema.maxLength,
            minLength: schema.minLength,
            pattern: schema.pattern
        )
    }

    init?(with schema: NumberSchema) {
        self.init(
            multipleOf: schema.multipleOf,
            maximum: schema.maximum,
            exclusiveMaximum: schema.exclusiveMaximum,
            minimum: schema.minimum,
            exclusiveMinimum: schema.exclusiveMinimum
        )
    }

    init?(with schema: ArraySchema) {
        self.init(
            maxItems: schema.maxItems,
            minItems: schema.minItems,
            uniqueItems: schema.uniqueItems
        )
    }

    init?(with schema: Schema) {
        if let stringSchema = schema as? StringSchema {
            self.init(with: stringSchema)
        } else if let numberSchema = schema as? NumberSchema {
            self.init(with: numberSchema)
        } else if let arraySchema = schema as? ArraySchema {
            self.init(with: arraySchema)
        } else {
            return nil
        }
    }
}
