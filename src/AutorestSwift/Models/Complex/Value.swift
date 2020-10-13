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

/// Common base interface for properties, parameters and the like.
class Value: Codable, LanguageShortcut {
    /// the schema of this Value
    public var schema: Schema

    // these properties we can set
    private var internalRequired: Bool?

    /// if the value is marked 'required'.
    public var required: Bool {
        return internalRequired ?? false
    }

    /// can null be passed in instead
    let nullable: Bool?

    /// the value that the remote will assume if this value is not present
    let assumedValue: String?

    /// the value that the client should provide if the consumer doesn't provide one
    let clientDefaultValue: String?

    /// a short description
    let summary: String?

    /// API versions that this applies to. Undefined means all versions
    let apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    let deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    let origin: String?

    /// External Documentation Links
    let externalDocs: ExternalDocumentation?

    /// Per-language information for this aspect
    public var language: Languages

    /// Per-protocol information for this aspect
    let `protocol`: Protocols

    /// additional metadata extensions dictionary
    let extensions: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case schema
        case required
        case nullable
        case assumedValue
        case clientDefaultValue
        case summary
        case apiVersions
        case deprecated
        case origin
        case externalDocs
        case language
        case `protocol`
        case extensions
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.schema = try Schema.decode(withContainer: container)!
        self.internalRequired = try? container.decode(Bool.self, forKey: .required)
        self.nullable = try? container.decode(Bool.self, forKey: .nullable)
        self.assumedValue = try? container.decode(String.self, forKey: .assumedValue)
        self.clientDefaultValue = try? container.decode(String.self, forKey: .clientDefaultValue)
        self.summary = try? container.decode(String.self, forKey: .summary)
        self.apiVersions = try? container.decode([ApiVersion].self, forKey: .apiVersions)
        self.deprecated = try? container.decode(Deprecation.self, forKey: .deprecated)
        self.origin = try? container.decode(String.self, forKey: .origin)
        self.externalDocs = try? container.decode(ExternalDocumentation.self, forKey: .externalDocs)
        self.language = try container.decode(Languages.self, forKey: .language)
        self.protocol = try container.decode(Protocols.self, forKey: .protocol)
        self.extensions = try? container.decode([String: AnyCodable].self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if schema != nil { try container.encode(schema, forKey: .schema) }
        if internalRequired != nil { try container.encode(internalRequired, forKey: .required) }
        if nullable != nil { try container.encode(nullable, forKey: .nullable) }
        if assumedValue != nil { try container.encode(assumedValue, forKey: .assumedValue) }
        if clientDefaultValue != nil { try container.encode(clientDefaultValue, forKey: .clientDefaultValue) }
        if summary != nil { try container.encode(summary, forKey: .summary) }
        if apiVersions != nil { try container.encode(apiVersions, forKey: .apiVersions) }
        if deprecated != nil { try container.encode(deprecated, forKey: .deprecated) }
        if origin != nil { try container.encode(origin, forKey: .origin) }
        if externalDocs != nil { try container.encode(externalDocs, forKey: .externalDocs) }
        try container.encode(language, forKey: .language)
        try container.encode(`protocol`, forKey: .protocol)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }

    var isSkipUrlEncoding: Bool {
        var skipUrlEncoding = false
        if let value = extensions?["x-ms-skip-url-encoding"]?.value as? Bool {
            skipUrlEncoding = value
        }
        return skipUrlEncoding
    }
}
