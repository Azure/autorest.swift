//
//  OperationGroup.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation


/// An operation group represents a container around set of operations
public class OperationGroup: Metadata {
    public let key: String

    public let operations: [Operation]

    enum CodingKeys: String, CodingKey {
        case operations
        case key = "$key"
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    key = try container.decode( String.self, forKey: .key)
    operations = try container.decode( [Operation].self, forKey: .operations)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(key, forKey: .key)
    try container.encode(operations, forKey: .operations)
     try super.encode(to: encoder)
    }
}
