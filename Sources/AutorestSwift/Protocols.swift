//
//  Protocols.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public struct Protocols: CodeModelProperty {
    public let properties: ProtocolsProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct ProtocolsProperties: CodeModelPropertyBundle {
    public let http: Protocol?

    public let amqp: Protocol?

    public let mqtt: Protocol?

    public let jsonrpc: Protocol?
}
