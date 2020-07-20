//
//  Request.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

public struct Request: MetadataProtocol {

    /// the parameter inputs to the operation
    public var parameters: [ParameterProtocol]?

    /// a filtered list of parameters that is (assumably) the actual method signature parameters
    public var signatureParameters: [ParameterProtocol]?

    // MARK: MetadataProtocol

    /// per-language information for this aspect
    public var language: Languages

    /// per-protocol information for this aspect
    public var `protocol`: Protocols

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
