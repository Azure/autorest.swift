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

/// Model that contains all the information required to generate a service API
class CodeModel: Codable, LanguageShortcut {
    let info: Info
    let schemas: Schemas
    let operationGroups: [OperationGroup]
    let globalParameters: [ParameterType]?
    let security: Security
    var language: Languages
    let `protocol`: Protocols
    let extensions: [String: AnyCodable]?

    /// Lookup a schema by name.
    func schema(for name: String, withType type: AllSchemaTypes) -> Schema? {
        return schemas.schema(for: name, withType: type)
    }

    /// Lookup a global parameter by name.
    func globalParameter(for name: String) -> ParameterType? {
        return globalParameters?.first(named: name)
    }

    /// Lookup a model by name
    func object(for name: String) -> ObjectSchema? {
        let values = schemas.objects?.filter { $0.name == name } ?? []
        assert(values.count <= 1, "Expected, at most, one item.")
        return values.first
    }

    func getApiVersion() -> String {
        if let constantSchema = globalParameter(for: "api-version")?.schema as? ConstantSchema {
            return constantSchema.value.value
        } else if let constantSchema = globalParameter(for: "x-ms-version")?.schema as? ConstantSchema {
            return constantSchema.value.value
        } else {
            return ""
        }
    }

    var pagingNames: Language.PagingNames? {
        for group in operationGroups {
            for operation in group.operations {
                if let pagingMetadata = operation.extensions?["x-ms-pageable"]?.value as? [String: String] {
                    return Language.PagingNames(from: pagingMetadata)
                }
            }
        }
        return nil
    }
}

extension CodeModel {
    var packageName: String {
        let strippedSuffixes = ["service", "client"]
        var nameComps = name.splitAndJoinAcronyms

        while nameComps.count > 0 {
            guard let last = nameComps.last else { break }
            if strippedSuffixes.contains(last) {
                nameComps = Array(nameComps.dropLast())
                continue
            } else {
                break
            }
        }
        // capitalize each word and join
        for (index, comp) in nameComps.enumerated() {
            nameComps[index] = comp.capitalized
        }
        return nameComps.joined()
    }
}
