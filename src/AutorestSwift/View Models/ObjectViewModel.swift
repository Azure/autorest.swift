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

/// View Model for a class or struct defintion.
/// Example:
///   // a simple model object
///   public struct ModelObject { ... }
struct ObjectViewModel {
    let name: String
    let inheritance: String
    let comment: ViewModelComment
    var objectType = "struct"
    let properties: [PropertyViewModel]
    let constants: [PropertyViewModel]
    let isErrorType: Bool

    init(from schema: ObjectSchema) {
        self.name = schema.name
        self.comment = ViewModelComment(from: schema.description)

        // flatten out inheritance hierarchies so we can use structs
        var props = [PropertyViewModel]()
        var consts = [PropertyViewModel]()
        for property in schema.flattenedProperties ?? [] {
            if property.schema as? ConstantSchema != nil {
                consts.append(PropertyViewModel(from: property))
            } else {
                props.append(PropertyViewModel(from: property))
            }
        }
        self.properties = props
        self.constants = consts

        let isErrorType = (schema.usage.count > 0) ? (schema.usage.first == SchemaContext.exception) : false
        self.isErrorType = isErrorType
        let parents = isErrorType ? ["Codable", "Swift.Error"] : ["Codable"]
        self.inheritance = parents.joined(separator: ", ")
        checkForCircularReferences(withSchema: schema)
    }

    init(from schema: GroupSchema) {
        self.name = schema.name
        self.comment = ViewModelComment(from: schema.description)

        var props = [PropertyViewModel]()
        var consts = [PropertyViewModel]()
        for property in schema.properties ?? [] {
            if property.schema as? ConstantSchema != nil {
                consts.append(PropertyViewModel(from: property))
            } else {
                props.append(PropertyViewModel(from: property))
            }
        }
        self.properties = props
        self.constants = consts

        let isErrorType = (schema.usage.count > 0) ? (schema.usage.first == SchemaContext.exception) : false
        self.isErrorType = isErrorType
        let parents = isErrorType ? ["Codable", "Swift.Error"] : ["Codable"]
        self.inheritance = parents.joined(separator: ", ")
        checkForCircularReferences()
    }

    init(from schema: Schema) {
        self.name = schema.name
        self.comment = ViewModelComment(from: schema.description)

        var props = [PropertyViewModel]()
        var consts = [PropertyViewModel]()
        for property in schema.properties ?? [] {
            if property.schema as? ConstantSchema != nil {
                consts.append(PropertyViewModel(from: property))
            } else {
                props.append(PropertyViewModel(from: property))
            }
        }
        self.properties = props
        self.constants = consts
        self.isErrorType = false

        self.inheritance = "Codable"
        checkForCircularReferences()
    }

    private mutating func checkForCircularReferences(withSchema _: ObjectSchema? = nil) {
        // a struct cannot contain a circular reference, so these must be class types
        for property in properties {
            // remove any ? optionality
            var type = property.type
            if type.hasSuffix("?") {
                type.removeLast()
            }
            type = type.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = name.trimmingCharacters(in: .whitespacesAndNewlines)
            if key == type {
                objectType = "final class"
                return
            }
        }
    }
}
