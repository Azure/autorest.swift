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

class Schema: Codable, LanguageShortcut {
    /// Per-language information for Schema
    public var language: Languages

    /// The schema type
    let type: AllSchemaTypes

    /// A short description
    let summary: String?

    /// Example information
    let example: String?

    /// If the value isn't sent on the wire, the service will assume this
    let defaultValue: String?

    /// Per-serialization information for this Schema
    let serialization: SerializationFormats?

    /// API versions that this applies to. Undefined means all versions
    let apiVersions: [ApiVersion]?

    /// Deprecation information -- ie, when this aspect doesn't apply and why
    let deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    let origin: String?

    /// External Documentation Links
    let externalDocs: ExternalDocumentation?

    /// Per-protocol information for this aspect
    let `protocol`: Protocols

    let properties: [Property]?

    /// Additional metadata extensions dictionary
    let extensions: AnyCodable?

    var swiftType: String {
        switch type {
        case AllSchemaTypes.string:
            return "String"
        case AllSchemaTypes.boolean:
            return "Bool"
        case AllSchemaTypes.array:
            if let arraySchema = self as? ArraySchema {
                return "[\(arraySchema.elementType.name)]"
            } else {
                return "[\(name)]"
            }
        case AllSchemaTypes.dateTime:
            return "Date"
        case AllSchemaTypes.integer:
            return "Int"
        default:
            return name
        }
    }
}
