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

    // TODO: Apply allOf
    // public let allOf: [Metadata]?
}
