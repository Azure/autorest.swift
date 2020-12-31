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

/// represents a single callable endpoint with a discrete set of inputs, and any number of output possibilities (responses or exceptions)
class Operation: Codable, LanguageShortcut {
    /// common parameters when there are multiple requests
    let parameters: [ParameterType]?

    /// a common filtered list of parameters that is (assumably) the actual method signature parameters
    let signatureParameters: [ParameterType]?

    /// the different possibilities to build the request.
    let requests: [Request]?

    /// responses that indicate a successful call
    let responses: [Response]?

    /// responses that indicate a failed call
    let exceptions: [Response]?

    /// the apiVersion to use for a given profile name
    let profile: [String: ApiVersion]?

    /// a short description
    let summary: String?

    /// API versions that this applies to. Undefined means all versions
    let apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    let deprecated: Deprecation?

    /// where did this aspect come from (jsonpath or 'modelerfour:<something>')
    let origin: String?

    /// External Documentation Links
    let externalDocs: ExternalDocumentation?

    /// per-language information for this aspect
    public var language: Languages

    /// per-protocol information for this aspect
    let `protocol`: Protocols

    /// additional metadata extensions dictionary
    let extensions: [String: AnyCodable]?

    /// The request corresponding to this operation
    var request: Request? {
        assert(
            requests?.count ?? 0 <= 1,
            "Multiple requests per operation is currently not supported. Operation: \(name)"
        )
        return requests?.first
    }

    /// Returns the combined list of `ParameterType` objects.
    var allParams: [ParameterType] {
        let paramList = (signatureParameters ?? []) + (parameters ?? []) + (request?.allParams ?? [])
        var params = [ParameterType]()
        for param in paramList {
            if !params.contains(param) {
                params.append(param)
            }
        }
        return params
    }

    var returnsList: Bool {
        for response in responses ?? [] {}
        return false
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case parameters, signatureParameters, requests, responses, exceptions, profile, summary, apiVersions,
            deprecated,
            origin, externalDocs, language, `protocol`, extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var responses = [Response]()
        var responsesContainer = try container.nestedUnkeyedContainer(forKey: .responses)
        while !responsesContainer.isAtEnd {
            if let response = (try? responsesContainer.decode(SchemaResponse.self)) ??
                (try? responsesContainer.decode(Response.self)) {
                responses.append(response)
            }
        }
        self.responses = responses

        if var exceptionContainer = try? container.nestedUnkeyedContainer(forKey: .exceptions) {
            var exceptions = [Response]()
            while !exceptionContainer.isAtEnd {
                if let exception = (try? exceptionContainer.decode(SchemaResponse.self)) ??
                    (try? exceptionContainer.decode(Response.self)) {
                    exceptions.append(exception)
                }
            }
            self.exceptions = exceptions
        } else {
            self.exceptions = nil
        }

        self.parameters = try? container.decode([ParameterType].self, forKey: .parameters)
        self.signatureParameters = try? container.decode([ParameterType].self, forKey: .signatureParameters)
        self.requests = try? container.decode([Request].self, forKey: .requests)
        self.profile = try? container.decode([String: ApiVersion].self, forKey: .profile)
        self.summary = try? container.decode(String.self, forKey: .summary)
        self.apiVersions = try? container.decode([ApiVersion].self, forKey: .apiVersions)
        self.deprecated = try? container.decode(Deprecation.self, forKey: .deprecated)
        self.origin = try? container.decode(String.self, forKey: .origin)
        self.externalDocs = try? container.decode(ExternalDocumentation.self, forKey: .externalDocs)
        self.extensions = try? container.decode([String: AnyCodable].self, forKey: .extensions)
        self.language = try container.decode(Languages.self, forKey: .language)
        self.protocol = try container.decode(Protocols.self, forKey: .protocol)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parameters, forKey: .parameters)
        try container.encode(signatureParameters, forKey: .signatureParameters)
        try container.encode(requests, forKey: .requests)
        try container.encode(responses, forKey: .responses)
        if exceptions != nil { try container.encode(exceptions, forKey: .exceptions) }
        if profile != nil { try container.encode(profile, forKey: .profile) }
        if summary != nil { try container.encode(summary, forKey: .summary) }
        try container.encode(apiVersions, forKey: .apiVersions)
        if deprecated != nil { try container.encode(deprecated, forKey: .deprecated) }
        if origin != nil { try container.encode(origin, forKey: .origin) }
        if externalDocs != nil { try container.encode(externalDocs, forKey: .externalDocs) }
        try container.encode(language, forKey: .language)
        try container.encode(`protocol`, forKey: .protocol)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }

    /// Lookup a signatureParameter by name.
    func signatureParameter(for name: String) -> ParameterType? {
        return signatureParameters?.first(named: name)
    }

    /// Lookup a parameter by name.
    func parameter(for name: String) -> ParameterType? {
        return parameters?.first(named: name)
    }
}
