//
//  MetadataProtocol.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Common pattern for Metadata on aspects
public protocol MetadataProtocol: Codable {
    /// per-language information for this aspect
    var language: Languages { get set }

    /// per-protocol information for this aspect
    var `protocol`: Protocols  { get set }

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?  { get set }
}
