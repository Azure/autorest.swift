//
//  Response.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

public protocol ResponseInterface: MetadataInterface {}

public struct Response: ResponseInterface {
    /// per-language information for this aspect
    public let language: Languages

    /// per-protocol information for this aspect
    public let `protocol`: Protocols
}
