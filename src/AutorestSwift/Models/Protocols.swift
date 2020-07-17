//
//  Protocols.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public struct Protocols: Codable {
    public let http: ProtocolInterface?

    public let amqp: ProtocolInterface?

    public let mqtt: ProtocolInterface?

    public let jsonrpc: ProtocolInterface?

    enum CodingKeys: String, CodingKey {
        case http, amqp, mqtt, jsonrpc
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        http = try? container.decode(HttpParameter.self, forKey: .http)
        amqp = nil
        mqtt = nil
        jsonrpc = nil
//        amqp = try container.decode(ProtocolInterface.self, forKey: .amqp)
//        mqtt = try container.decode(ProtocolInterface.self, forKey: .mqtt)
//        jsonrpc = try container.decode(ProtocolInterface.self, forKey: .jsonrpc)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(http as? HttpParameter, forKey: .http)
//        try container.encode(amqp, forKey: .amqp)
//        try container.encode(mqtt, forKey: .mqtt)
//        try container.encode(jsonrpc, forKey: .jsonrpc)
    }
}
