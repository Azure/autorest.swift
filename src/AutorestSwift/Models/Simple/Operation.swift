//
//  Operation.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

/// represents a single callable endpoint with a discrete set of inputs, and any number of output possibilities (responses or exceptions)
public struct Operation: Codable {
    /// common parameters when there are multiple requests
    public var parameters: [ParameterProtocol]?

    /// a common filtered list of parameters that is (assumably) the actual method signature parameters
    public var signatureParameters: [ParameterProtocol]?

    /// the different possibilities to build the request.
    public var requests: [Request]?

    /// responses that indicate a successful call
    public var responses: [ResponseProtocol]?

    /// responses that indicate a failed call
    public var exceptions: [ResponseProtocol]?

    /// the apiVersion to use for a given profile name
    public var profile: [String: ApiVersion]?

    /// a short description
    public var summary: String?

    /// API versions that this applies to. Undefined means all versions
    public var apiVersions: [ApiVersion]?

    /// deprecation information -- ie, when this aspect doesn't apply and why
    public var deprecated: Deprecation?

    /// where did this aspect come from (jsonpath or 'modelerfour:<something>')
    public var origin: String?

    /// External Documentation Links
    public var externalDocs: ExternalDocumentation?

    /// per-language information for this aspect
    public var language: Languages

    /// per-protocol information for this aspect
    public var `protocol`: Protocols

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?

    public enum CodingKeys: String, CodingKey {
        case parameters, signatureParameters, requests, responses, exceptions, profile, summary, apiVersions,
            deprecated,
            origin, externalDocs, language, `protocol`
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // TODO: Extract this logic to ResponseInterface extension
        responses = (try? container.decode([SchemaResponse].self, forKey: .responses)) ??
            (try? container.decode([ResponseProtocol].self, forKey: .responses))

        exceptions = (try? container.decode([SchemaResponse].self, forKey: .exceptions)) ??
            (try? container.decode([ResponseProtocol].self, forKey: .exceptions))

        parameters = try? container.decode([ParameterProtocol].self, forKey: .parameters)
        signatureParameters = try? container.decode([ParameterProtocol].self, forKey: .signatureParameters)
        requests = try? container.decode([Request].self, forKey: .requests)
        profile = try? container.decode([String: ApiVersion].self, forKey: .profile)
        summary = try? container.decode(String.self, forKey: .summary)
        apiVersions = try? container.decode([ApiVersion].self, forKey: .apiVersions)
        deprecated = try? container.decode(Deprecation.self, forKey: .deprecated)
        origin = try? container.decode(String.self, forKey: .origin)
        externalDocs = try? container.decode(ExternalDocumentation.self, forKey: .externalDocs)
        language = try container.decode(Languages.self, forKey: .language)
        `protocol` = try container.decode(Protocols.self, forKey: .protocol)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(parameters, forKey: .parameters)
        try container.encode(signatureParameters, forKey: .signatureParameters)
        try container.encode(requests, forKey: .requests)
        if responses is [SchemaResponse] {
            try container.encode(responses as? [SchemaResponse], forKey: .responses)
        } else if responses is [ResponseProtocol] {
            try container.encode(responses as? [ResponseProtocol], forKey: .responses)
        }
        if exceptions is [SchemaResponse] {
            try container.encode(responses as? [SchemaResponse], forKey: .exceptions)
        } else if responses is [ResponseProtocol] {
            try container.encode(responses as? [ResponseProtocol], forKey: .exceptions)
        }
        if profile != nil { try container.encode(profile, forKey: .profile) }
        if summary != nil { try container.encode(summary, forKey: .summary) }
        try container.encode(apiVersions, forKey: .apiVersions)
        if deprecated != nil { try container.encode(deprecated, forKey: .deprecated) }
        if origin != nil { try container.encode(origin, forKey: .origin) }
        if externalDocs != nil { try container.encode(externalDocs, forKey: .externalDocs) }
        try container.encode(language, forKey: .language)
        try container.encode(`protocol`, forKey: .protocol)
    }
}
