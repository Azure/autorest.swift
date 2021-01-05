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
    /// The parameter path
    let path: String

    /// whether property is optional or not
    let optional: Bool

    /// original parameter type
    let paramType: String

    /// indicates whether max length validation is specified
    let hasMaxLength: Bool

    /// the maximum length of the string
    let maxLength: Int?

    /// indicates whether min length validation is specified
    let hasMinLength: Bool

    /// the minimum length of the string
    let minLength: Int?

    /// indicates whether pattern validation is specified
    let hasPattern: Bool

    /// a regular expression that the string must be validated against
    let pattern: String?

    /// indicates whether multipleOf validation is specified
    let hasMultipleOf: Bool

    /// if present, the number must be an exact multiple of this value
    let multipleOf: Int?

    /// indicates whether maximum validation is specified
    let hasMaximum: Bool

    /// if present, the value must be lower than or equal to this (unless exclusiveMaximum is true)
    let maximum: Int?

    /// if present, the value must be lower than maximum
    let exclusiveMaximum: Bool?

    /// indicates whether minimum validation is specified
    let hasMinimum: Bool

    /// if present, the value must be highter than or equal to this (unless exclusiveMinimum is true)
    let minimum: Int?

    /// if present, the value must be higher than minimum
    let exclusiveMinimum: Bool?

    /// indicates whether max items validation is specified
    let hasMaxItems: Bool

    /// maximum number of elements in the array
    let maxItems: Int?

    /// indicates whether min items validation is specified
    let hasMinItems: Bool

    /// minimum number of elements in the array
    let minItems: Int?

    /// indicates whether uniqueItems validation is specified
    let hasUniqueItems: Bool

    /// if the elements in the array should be unique
    let uniqueItems: Bool?

    init?(
        path: String,
        paramType: String,
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
        self.path = path
        self.paramType = paramType
        self.optional = path.contains("?")

        self.maxLength = maxLength
        self.hasMaxLength = maxLength != nil

        self.minLength = minLength
        self.hasMinLength = minLength != nil

        self.pattern = pattern
        self.hasPattern = pattern != nil

        self.multipleOf = multipleOf
        self.hasMultipleOf = multipleOf != nil

        self.maximum = maximum
        self.exclusiveMaximum = exclusiveMaximum
        self.hasMaximum = maximum != nil

        self.minimum = minimum
        self.exclusiveMinimum = exclusiveMinimum
        self.hasMinimum = minimum != nil

        self.maxItems = maxItems
        self.hasMaxItems = maxItems != nil

        self.minItems = minItems
        self.hasMinItems = minItems != nil

        self.uniqueItems = uniqueItems
        self.hasUniqueItems = uniqueItems != nil
    }

    init?(with schema: StringSchema, path: String) {
        self.init(
            path: path,
            paramType: schema.swiftType(),
            maxLength: schema.maxLength,
            minLength: schema.minLength,
            pattern: schema.pattern
        )
    }

    init?(with schema: NumberSchema, path: String) {
        self.init(
            path: path,
            paramType: schema.swiftType(),
            multipleOf: schema.multipleOf,
            maximum: schema.maximum,
            exclusiveMaximum: schema.exclusiveMaximum,
            minimum: schema.minimum,
            exclusiveMinimum: schema.exclusiveMinimum
        )
    }

    init?(with schema: ArraySchema, path: String) {
        self.init(
            path: path,
            paramType: schema.swiftType(),
            maxItems: schema.maxItems,
            minItems: schema.minItems,
            uniqueItems: schema.uniqueItems
        )
    }

    init?(with schema: Schema, path: String) {
        if let stringSchema = schema as? StringSchema {
            self.init(with: stringSchema, path: path)
        } else if let numberSchema = schema as? NumberSchema {
            self.init(with: numberSchema, path: path)
        } else if let arraySchema = schema as? ArraySchema {
            self.init(with: arraySchema, path: path)
        } else if let constSchema = schema as? ConstantSchema {
            self.init(with: constSchema.valueType, path: path)
        } else {
            return nil
        }
    }

    public static func from(
        objectSchema schema: ObjectSchema,
        withPrefix prefix: String
    ) -> [String: Validation]? {
        var validations = [String: Validation]()
        for property in schema.properties ?? [] {
            let path = prefix.isEmpty ? property.name : "\(prefix).\(property.name)"
            if let objectSchema = property.schema as? ObjectSchema {
                var newPrefix = prefix.isEmpty ? property.name : "\(prefix).\(property.name)"
                if !property.required {
                    newPrefix = "\(newPrefix)?"
                }
                if let objectValidations = Validation.from(objectSchema: objectSchema, withPrefix: newPrefix) {
                    validations.merge(objectValidations) { _, latest in latest }
                }
            } else if let validation = Validation(with: property.schema, path: path) {
                validations[path] = validation
            }
        }
        return validations.isEmpty ? nil : validations
    }
}
