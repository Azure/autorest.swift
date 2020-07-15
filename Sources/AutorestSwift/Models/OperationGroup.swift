//
//  OperationGroup.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

public typealias OperationGroup = Compose<OperationGroupProperty, Metadata>

/// An operation group represents a container around set of operations
public struct OperationGroupProperty: Codable {
    public let key: String

    public let operations: [Operation]

    enum CodingKeys: String, CodingKey {
        case operations
        case key = "$key"
    }
}
