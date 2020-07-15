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
    public let profile: Dictionary<String, ApiVersion>?

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
    public let languages: Languages

    /// per-protocol information for this aspect
    public let protocols: Protocols

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public let extensions: Dictionary<AnyHashable, Codable>?
}
