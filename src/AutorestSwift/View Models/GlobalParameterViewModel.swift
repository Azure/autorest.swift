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

/// View Model for a key-value pair, as used in Dictionaries.
/// Example:
///     "key" = value
struct GlobalParameterViewModel {
    /// key of the Key-Value pair
    let name: String
    /// value of the Key-Value pair
    let type: String
    let value: String

    init(from param: ParameterType) throws {
        self.name = param.serializedName ?? param.name

        if let constantSchema = param.schema as? ConstantSchema {
            let swiftType = constantSchema.valueType.swiftType()
            self.type = swiftType
            let value = constantSchema.value.value

            switch constantSchema.valueType.type {
            case AllSchemaTypes.boolean:
                self.value = constantSchema.value.value
            case AllSchemaTypes.string:
                self.value = "\"\(constantSchema.value.value))\""
            case AllSchemaTypes.date,
                 AllSchemaTypes.dateTime:
                self.value = "String(\"\(value)\")"
            default:

                self.value = constantSchema.value.value
                print(
                    "default 3333 name: \(name) type: \(constantSchema.valueType.type.rawValue)  value: \(value)"
                )
            }

            print(
                "222 name: \(name) type: \(constantSchema.valueType.type.rawValue)  value: \(self.value)"
            )
        } else if let stringSchema = param.schema as? StringSchema {
            let swiftType = stringSchema.swiftType()
            self.type = swiftType
            assert(stringSchema.type == AllSchemaTypes.string)
            self.value = "\"unknown\""

            print(
                "333 hard code to a unknown name: \(name) type: \(param.schema.type.rawValue)  value: \(value)"
            )
        } else {
            throw CodeGenerationError.general("value not round")
        }
    }
}
