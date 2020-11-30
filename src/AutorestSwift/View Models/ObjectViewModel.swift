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

class FlattenedNode {
    let name: String
    let serializedName: String
    let swiftName: String
    var children: [FlattenedNode] = []
    var properties: [PropertyViewModel] = []
    var hasChild: Bool
    // let initArgument: String

    init(name: String, serializedName: String) {
        self.name = name
        self.serializedName = serializedName
        self.swiftName = name.uppercasedFirst
        self.hasChild = false
    }

    func add(property: PropertyViewModel) {
        properties.append(property)
    }

    func add(child: FlattenedNode) {
        children.append(child)
        hasChild = true
    }

    func findChild(with name: String) -> FlattenedNode? {
        return children.first(where: { $0.name == name })
    }

    /* func getInitArgument() -> String {
         var initArgument: String = ""

         for swiftStruct1 in model.swiftStructs {
             for property in swiftStruct1.properties {
                 {{ property.name }}: {{ property.name }}{% ifnot forloop.last %},{% endif%}
             }
         }
     }*/
}

private func findName(with name: String, from nodes: [FlattenedNode]) -> FlattenedNode? {
    return nodes.first(where: { $0.name == name })
}

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
    var swiftStructs: [FlattenedNode]
    let rootFlattenedNode: FlattenedNode
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

        let rootNode: FlattenedNode = FlattenedNode(name: "root", serializedName: "root")
        var currentNode = rootNode
        for propertyType in schema.flattenedProperties ?? [] {
            if let flattenedNames = propertyType.flattenedNames {
                for i in 0 ..< flattenedNames.count {
                    let name = flattenedNames[i]
                    if let node = currentNode.findChild(with: name) {
                        currentNode = node
                    } else if i == (flattenedNames.count - 1) {
                        currentNode.add(property: PropertyViewModel(from: propertyType))
                    } else if case let .regular(property) = propertyType {
                        let serializedName = property.serializedName
                        let node = FlattenedNode(name: name, serializedName: name)
                        currentNode.add(child: node)
                        currentNode = node
                    }
                }
                currentNode = rootNode

            } else if let constSchema = propertyType.schema as? ConstantSchema {
                consts.append(ConstantViewModel(from: constSchema))
            } else {
                props.append(PropertyViewModel(from: propertyType))
            }
        }

        self.rootFlattenedNode = rootNode
        self.swiftStructs = []

        self.properties = props
        self.constants = consts
        self.hasConstants = !consts.isEmpty
        self.hasProperty = properties.count > 0

        self.swiftStructs = []
        buildSwiftStructs(node: rootNode)
        checkForErrorType(with: schema)
        checkForCircularReferences()
    }

    private mutating func buildSwiftStructs(node: FlattenedNode) {
        swiftStructs.append(contentsOf: node.children)
        for child in node.children {
            buildSwiftStructs(node: child)
        }
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

        self.rootFlattenedNode = FlattenedNode(name: "", serializedName: "")
        self.swiftStructs = []
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
