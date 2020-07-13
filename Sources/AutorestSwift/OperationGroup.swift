//
//  OperationGroup.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// An operation group represents a container around set of operations
public struct OperationGroup: CodeModelProperty {
    public let properties: OperationGroupProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [Metadata]?
}

public struct OperationGroupProperties: CodeModelPropertyBundle {
    public let key: String

    public let operations: [Operation]
}
