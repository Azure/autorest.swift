//
//  Operation.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

/// represents a single callable endpoint with a discrete set of inputs, and any number of output possibilities (responses or exceptions)
public class Operation: Codable {
    /// common parameters when there are multiple requests
    public let parameters: [Parameter]?

    /// a common filtered list of parameters that is (assumably) the actual method signature parameters
    public let signatureParameters: [Parameter]?

    /// the different possibilities to build the request.
    public let requests: [Request]?

    /// responses that indicate a successful call
    public let responses: [Response]?

    /// responses that indicate a failed call
    public let exceptions: [Response]?

    /// the apiVersion to use for a given profile name
    public let profile: [String: ApiVersion]?

    /// a short description
    public let summary: String?

    /// API versions that this applies to. Undefined means all versions
    public let apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    public let deprecated: Deprecation?

    /// where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public let origin: String?

    /// External Documentation Links
    public let externalDocs: ExternalDocumentation?

    /// per-language information for this aspect
    public let language: Languages

    /// per-protocol information for this aspect
    public let `protocol`: Protocols

    /// additional metadata extensions dictionary
    public let extensions: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case parameters, signatureParameters, requests, responses, exceptions, profile, summary, apiVersions,
            deprecated,
            origin, externalDocs, language, `protocol`, extensions
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        responses = (try? container.decode([SchemaResponse].self, forKey: .responses)) ??
            (try? container.decode([Response].self, forKey: .responses))

        exceptions = (try? container.decode([SchemaResponse].self, forKey: .exceptions)) ??
            (try? container.decode([Response].self, forKey: .exceptions))

        parameters = try? container.decode([Parameter].self, forKey: .parameters)
        signatureParameters = try? container.decode([Parameter].self, forKey: .signatureParameters)
        requests = try? container.decode([Request].self, forKey: .requests)
        profile = try? container.decode([String: ApiVersion].self, forKey: .profile)
        summary = try? container.decode(String.self, forKey: .summary)
        apiVersions = try? container.decode([ApiVersion].self, forKey: .apiVersions)
        deprecated = try? container.decode(Deprecation.self, forKey: .deprecated)
        origin = try? container.decode(String.self, forKey: .origin)
        externalDocs = try? container.decode(ExternalDocumentation.self, forKey: .externalDocs)
        extensions = try? container.decode(AnyCodable.self, forKey: .extensions)
        language = try container.decode(Languages.self, forKey: .language)
        `protocol` = try container.decode(Protocols.self, forKey: .protocol)
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
        try container.encode(extensions, forKey: .extensions)
    }
}
