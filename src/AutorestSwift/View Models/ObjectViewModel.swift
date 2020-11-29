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
    let comment: ViewModelComment
    let properties: [PropertyViewModel]
    let constants: [ConstantViewModel]
    let hasConstants: Bool
    var flattenProperties: [String: [PropertyViewModel]]
    var inheritance = "NSObject"
    var objectType = "struct"
    var isErrorType = false
    let hasProperty: Bool

    init(from schema: ObjectSchema) {
        self.name = schema.modelName
        self.comment = ViewModelComment(from: schema.description)

        // flatten out inheritance hierarchies so we can use structs
        var props = [PropertyViewModel]()
        var consts = [ConstantViewModel]()
        var flattenProperties: [String: [PropertyViewModel]] = [:]

        for property in schema.flattenedProperties ?? [] {
            if property.flattenedNames?.count != 0,
                let name = property.flattenedNames?[0] {
                if flattenProperties.keys.contains(name) {
                    flattenProperties[name]?.append(PropertyViewModel(from: property))
                } else {
                    flattenProperties[name] = []
                    flattenProperties[name]?.append(PropertyViewModel(from: property))
                }
            } else if let constSchema = property.schema as? ConstantSchema {
                consts.append(ConstantViewModel(from: constSchema))
            } else {
                props.append(PropertyViewModel(from: property))
            }
        }
        self.flattenProperties = flattenProperties
        self.properties = props
        self.constants = consts
        self.hasConstants = !consts.isEmpty
        self.flattenProperties = flattenProperties
        self.hasProperty = properties.count > 0
        checkForErrorType(with: schema)
        checkForCircularReferences()
    }

    private mutating func checkForCircularReferences() {
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

    init(from schema: GroupSchema) {
        self.name = schema.modelName
        self.comment = ViewModelComment(from: schema.description)

        // flatten out inheritance hierarchies so we can use structs
        var props = [PropertyViewModel]()
        var consts = [ConstantViewModel]()
        let groupedProperties = schema.properties?.grouped ?? []
        assert(
            groupedProperties.count == (schema.properties?.count ?? 0),
            "Expected all properties to be group properties."
        )

        for property in groupedProperties {
            // the source of flattened parameters should not be included in the view model
            // FIXME: This assumption no longer holds for storage and should be revisited
            assert(property.originalParameter.count <= 1, "Expected, at most, one original parameter.")
            if property.originalParameter.first?.flattened ?? false {
                continue
            }
            if let constSchema = property.schema as? ConstantSchema {
                consts.append(ConstantViewModel(from: constSchema))
            } else {
                props.append(PropertyViewModel(from: property))
            }
        }
        self.flattenProperties = [:]
        self.properties = props
        self.constants = consts
        self.hasConstants = !consts.isEmpty
        self.hasProperty = properties.count > 0

        checkForErrorType(with: schema)
        checkForCircularReferences()
    }

    private mutating func checkForErrorType(with schema: UsageSchema) {
        let isErrorType = (schema.usage.count > 0) ? (schema.usage.first == SchemaContext.exception) : false
        self.isErrorType = isErrorType
        let parents = isErrorType ? ["Codable", "Swift.Error"] : ["Codable"]
        inheritance = parents.joined(separator: ", ")
    }
}
