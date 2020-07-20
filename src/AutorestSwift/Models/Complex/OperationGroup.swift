//
//  OperationGroup.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// An operation group represents a container around set of operations
public struct OperationGroup: MetadataProtocol {
    enum CodingKeys: String, CodingKey {
        case operations
        case key = "$key"
    }

    public var key: String? = nil

    public var operations: [Operation]? = nil

    // MARK: MetadataProtocol

    /// per-language information for this aspect
    public var language: Languages

    /// per-protocol information for this aspect
    public var `protocol`: Protocols

    /// additional metadata extensions dictionary
    // TODO: Not Codable
    // public var extensions: Dictionary<AnyHashable, Codable>?
}
