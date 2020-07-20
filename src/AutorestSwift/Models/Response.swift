//
//  Response.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

// public protocol ResponseInterface: MetadataInterface {}

public class Response: MetadataInterface {
    /// per-language information for this aspect
    public let language: Languages

    /// per-protocol information for this aspect
    public let `protocol`: Protocols
}
