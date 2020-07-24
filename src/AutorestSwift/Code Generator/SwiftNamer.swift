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

enum SdkRole: String {
    case service
    case operationGroup
    case operation
    case model
    case property
    case parameter
}

class SwiftNamer: CodeNamer {
    // MARK: Properties

    let model: CodeModel

    // MARK: Initializers

    required init(withModel model: CodeModel) {
        self.model = model
    }

    // MARK: Methods

    /// Begin naming process
    // swiftlint:disable cyclomatic_complexity
    func process() throws {
        let schemas = model.schemas

        // Name the client class from the service name
        name(for: model.language, inRole: .service)

        // Name global parameters
        for globalParam in model.globalParameters ?? [] {
            name(for: globalParam.language, inRole: .property)
            print(globalParam.name)
        }

        // Name operations and parameters
        for operationGroup in model.operationGroups {
            name(for: operationGroup.language, inRole: .operationGroup)
            for operation in operationGroup.operations {
                name(for: operation.language, inRole: .operation)
                for parameter in operation.parameters ?? [] {
                    name(for: parameter.language, inRole: .parameter)
                }
                for parameter in operation.signatureParameters ?? [] {
                    name(for: parameter.language, inRole: .parameter)
                }
            }
        }

        // Name models and properties
        for object in schemas.objects ?? [] {
            name(for: object.language, inRole: .model)
            for property in object.properties ?? [] {
                name(for: property.language, inRole: .property)
            }
        }

        // Name enums and enum options
        for choice in schemas.choices ?? [] {
            name(for: choice.language, inRole: .model)
            for value in choice.choices {
                name(for: value.language, inRole: .property)
            }
        }
        for choice in schemas.sealedChoices ?? [] {
            name(for: choice.language, inRole: .model)
            for value in choice.choices {
                name(for: value.language, inRole: .property)
            }
        }

        // Name constants
        for constant in schemas.constants ?? [] {
            name(for: constant.language, inRole: .property)
        }
    }

    /// accepts a `Languages` object with `.default` and returns a new `Languages` object with `.swift`.
    func name(for lang: Languages, inRole role: SdkRole) {
        var name = lang.swift.name
        switch role {
        case .service:
            name = clientName(for: name)
        case .operationGroup:
            name = name.toCamelCase
        case .operation:
            name = operationName(for: name)
        case .model:
            name = name.toPascalCase
        case .property:
            name = name.toCamelCase
        case .parameter:
            name = name.toCamelCase
        }
        lang.swift.name = name
    }

    private func clientName(for serviceName: String) -> String {
        var name = serviceName
        let stripList = ["Service", "Client"]
        for item in stripList {
            if name.hasSuffix(item) {
                name = String(name.dropLast(item.count))
            }
        }
        return "\(name)Client"
    }

    private func operationName(for operationName: String) -> String {
        let pluralReplacements = [
            "get": "list"
        ]

        var nameComps = operationName.splitAndJoinAcronyms

        // TODO: Need a more reliable way to know whether the last item is singular or plural
        let isPlural = nameComps.last?.hasSuffix("s") ?? false
        for (index, comp) in nameComps.enumerated() {
            if index == 0 {
                if isPlural, let replacement = pluralReplacements[comp] {
                    nameComps[index] = replacement
                }
            } else {
                nameComps[index] = comp.capitalized
            }
        }
        return nameComps.joined()
    }
}
