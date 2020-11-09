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

/// View Model for a model property.
/// Example:
///     // a simple property
///     let simple: String = "default"
struct PropertyViewModel {
    let name: String
    let comment: ViewModelComment
    let type: String
    // default value of the proeprty
    let defaultValue: ViewModelDefault
    // default value of the property in the init(). Valid values are either nil (for optional property) or "" (i.e. not specfied for required property in init() method.)
    let initDefaultValue: String
    let isDate: Bool
    let optional: Bool
    let className: String
    let serializedName: String?

    /// Initialize from Value type (such as Property or Parameter)
    init(from schema: Property) {
        let name = schema.serializedName ?? schema.name
        assert(!name.isEmpty)
        self.name = name
        self.serializedName = schema.serializedName
        self.comment = ViewModelComment(from: schema.description)
        self.className = schema.schema!.swiftType()
        self.optional = !schema.required
        self.type = optional ? "\(className)?" : className
        self.defaultValue = ViewModelDefault(from: schema.clientDefaultValue, isString: true, isOptional: optional)
        self.initDefaultValue = optional ? "= nil" : ""
        self.isDate = type.contains("Date")
    }

    init(from schema: PropertyType) {
        switch schema {
        case let .regular(reg):
            self.init(from: reg)
        case let .grouped(group):
            self.init(from: group)
        }
    }
}
