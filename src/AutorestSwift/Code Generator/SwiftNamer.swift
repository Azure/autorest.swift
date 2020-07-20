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

private enum SwiftSdkRole: String {
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

    init(withModel model: CodeModel) {
        self.model = model
    }

    // MARK: Methods

    /// Begin naming process
    func process() throws {
        // Iterate through entire model structure, examining any
        // language.default properties and using that to populate
        // language.swift
        swiftName(forLanguage: model.language, inRole: .service)

        for globalParam in model.globalParameters ?? [] {
            swiftName(forLanguage: globalParam.language, inRole: .property)
        }

        for operationGroup in model.operationGroups {
            swiftName(forLanguage: operationGroup.language, inRole: .operationGroup)
            for operation in operationGroup.operations {
                swiftName(forLanguage: operation.language, inRole: .operation)
                print("====COMMON PARAMS====")
                for parameter in operation.parameters ?? [] {
                    swiftName(forLanguage: parameter.language, inRole: .parameter)
                }
                print("====SIGNATURE PARAMS====")
                for parameter in operation.signatureParameters ?? [] {
                    swiftName(forLanguage: parameter.language, inRole: .parameter)
                }
            }
        }
    }
}

/// accepts a `Languages` object with `.default` and returns a new `Languages` object with `.swift`.
private func swiftName(forLanguage lang: Languages, inRole role: SwiftSdkRole) {
    switch role {
    case .service:
        // This should be the client name
        let stripList = ["Service", "Client"]
        var name = lang.swift.name
        for item in stripList {
            if name.hasSuffix(item) {
                name = String(name.dropLast(item.count))
            }
        }
        name = "\(name)Client"
        lang.swift.name = name
        break
    case .operationGroup:
        break
    case .operation:
        break
    case .model:
        break
    case .property:
        // TODO: verify camelCasing conventions
        break
    case .parameter:
        break
    }
    print("\(role.rawValue): \(lang.default.name) => \(lang.swift.name)")
}
