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

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        http = (try? container.decode(HttpParameter.self, forKey: .http)) ??
            (try? container.decode(HttpResponse.self, forKey: .http)) ??
            (try? container.decode(HttpModel.self, forKey: .http))
        // TODO: Finish implementation
        amqp = nil
        mqtt = nil
        jsonrpc = nil
    }

    public func encode(to encoder: Encoder) throws {
        // TODO: Finish implementation
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(http as? HttpParameter, forKey: .http)
    }
}
