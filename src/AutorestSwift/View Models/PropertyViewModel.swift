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
    let defaultValue: ViewModelDefault

    init(from schema: Property) {
        self.name = schema.name.toCamelCase
        self.comment = ViewModelComment(from: schema.description)
        let required = schema.required ?? false
        self.type = getType(from: schema.schema, optional: !required)
        self.defaultValue = ViewModelDefault(from: schema.clientDefaultValue, isString: true)
    }
}

func getType(from propertySchema: Schema, optional: Bool = false) -> String {
    var type: String
    switch propertySchema.type {
    case AllSchemaTypes.string:
        type = "String"
    case AllSchemaTypes.boolean:
        type = "Bool"
    case AllSchemaTypes.array:
        if let arraySchema = propertySchema as? ArraySchema {
            type = "[\(arraySchema.elementType.name)]"
        } else {
            type = "[\(propertySchema.name)]"
        }
    case AllSchemaTypes.dateTime:
        type = "Date"
    case AllSchemaTypes.integer:
        type = "Int"
    default:
        type = propertySchema.name
    }

    return optional ? "\(type)?" : type
}
