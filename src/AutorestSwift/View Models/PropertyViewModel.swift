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

/// View Model for an struct property.
/// Example:
///     // a simple property
///     let simple: String = "default"
struct PropertyViewModel {
    let name: String
    let comment: ViewModelComment
    let type: String
    // default value of the proeprty
    let defaultValue: ViewModelDefault
    // default value of the property in the init(). Valid values are either nil (for optoinal property) or "" (i.e. not specfied for required property in init() method.)
    let initDefaultValue: String
    let isDate: Bool
    let optional: Bool
    let className: String

    /// Initialize from Value type (such as Property or Parameter)
    init(from schema: Value) {
        self.name = schema.serializedName ?? schema.name
        self.comment = ViewModelComment(from: schema.description)
        self.className = schema.schema.swiftType()
        self.optional = !schema.required
        self.type = optional ? "\(className)?" : className
        self.defaultValue = ViewModelDefault(from: schema.clientDefaultValue, isString: true)
        self.initDefaultValue = optional ? "= nil" : ""
        self.isDate = type.contains("Date")
    }

    init(from param: ParameterType) throws {
        var defaultValue: String
        self.name = param.serializedName ?? param.name
        self.comment = ViewModelComment(from: param.schema.description)

        var includeEqualSign: Bool = true
        if let constantSchema = param.schema as? ConstantSchema {
            let swiftType = constantSchema.valueType.swiftType()
            self.type = swiftType
            self.className = type
            let value = constantSchema.value.value

            switch constantSchema.valueType.type {
            case AllSchemaTypes.boolean:
                defaultValue = constantSchema.value.value
            case AllSchemaTypes.string:
                defaultValue = "\"\(constantSchema.value.value))\""
            case AllSchemaTypes.date,
                 AllSchemaTypes.dateTime:
                defaultValue = "\"\(constantSchema.value.value))\"" // "DateFormatter().date(from:(\"\(value)\"))"
                includeEqualSign = false
            default:
                defaultValue = constantSchema.value.value
                print(
                    "default 3333 name: \(name) type: \(constantSchema.valueType.type.rawValue) swiftType: \(swiftType) value: \(value)"
                )
            }

            print(
                "222 name: \(name) type: \(constantSchema.valueType.type.rawValue)  value: \(defaultValue)"
            )

        } else {
            throw CodeGenerationError.general("value not round")
        }

        self.optional = false
        self.defaultValue = ViewModelDefault(from: defaultValue, isString: false, includeEqualSign: includeEqualSign)

        self.initDefaultValue = ""
        self.isDate = type.contains("Date")
    }
}
