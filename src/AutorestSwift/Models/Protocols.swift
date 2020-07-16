//
//  Protocols.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public struct Protocols: Codable {
    public let http: Protocol<Codable>?

    public let amqp: Protocol<Codable>?

    public let mqtt: Protocol<Codable>?

    public let jsonrpc: Protocol<Codable>?
}
