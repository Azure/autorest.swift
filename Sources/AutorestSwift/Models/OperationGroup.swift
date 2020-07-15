//
//  OperationGroup.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// An operation group represents a container around set of operations
public struct OperationGroup: Codable {
    public let key: String

    public let operations: [Operation]

    enum CodingKeys: String, CodingKey {
        case operations, key = "$key"
    }
    
    // TODO: Apply allOf
    // public let allOf: [Metadata]?
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(operations, forKey: .operations)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        operations = try container.decode([Operation].self, forKey: .operations)
    }
}
