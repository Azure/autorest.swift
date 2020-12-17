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
    /// The name of the property
    let name: String
    /// The property name that the service expects over the wire
    let serializedName: String
    /// The docstring associated with the property
    let comment: ViewModelComment
    /// The Swift type for the property (`String`, `MyClass`, etc)
    let type: String
    /// default value of the property
    let defaultValue: ViewModelDefault
    /// default value of the property in the init(). Valid values are either nil (for optional property) or "" (i.e. not specfied for required property in init() method.)
    let initDefaultValue: String
    /// Whether the property is required or not
    let optional: Bool
    // FIXME: This is just the type without the ? (if optional). A better way?
    let className: String

    /// Initialize a `PropertyViewModel` directly
    init(
        name: String,
        type: String,
        serializedName: String? = nil,
        comment: String? = nil,
        defaultValue: String? = nil,
        initDefaultValue: String? = nil,
        optional: Bool = false,
        className: String? = nil
    ) {
        self.name = name
        self.type = type
        self.serializedName = serializedName ?? name
        self.comment = ViewModelComment(from: comment)
        self.defaultValue = ViewModelDefault(from: defaultValue, isString: true, isOptional: optional)
        self.initDefaultValue = initDefaultValue ?? ""
        self.optional = optional
        self.className = className ?? type
    }

    /// Initialize from Value type (such as Property or Parameter)
    init(from schema: Value) {
        // The `name` field is preferred.
        let name = schema.name
        assert(!name.isEmpty)
        self.name = name
        self.comment = ViewModelComment(from: schema.description)
        self.className = schema.schema!.swiftType()
        self.optional = !schema.required
        self.type = optional ? "\(className)?" : className
        self.defaultValue = ViewModelDefault(from: schema.clientDefaultValue, isString: true, isOptional: optional)
        self.initDefaultValue = optional ? "= nil" : ""
        if let flattenedNames = (schema as? Property)?.flattenedNames {
            self.serializedName = flattenedNames.joined(separator: ".")
        } else {
            self.serializedName = schema.serializedName ?? name
        }
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
