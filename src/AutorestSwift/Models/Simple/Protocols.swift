//
//  Protocols.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public struct Protocols: Codable {
    public var http: ProtocolProtocol?

    public var amqp: ProtocolProtocol?

    public var mqtt: ProtocolProtocol?

    public var jsonrpc: ProtocolProtocol?

    enum CodingKeys: String, CodingKey {
        case http, amqp, mqtt, jsonrpc
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        http = (try? container.decode(HttpWithBodyRequestProtocol.self, forKey: .http)) ??
            (try? container.decode(HttpParameter.self, forKey: .http)) ??
            (try? container.decode(HttpResponse.self, forKey: .http)) ??
            (try? container.decode(HttpModel.self, forKey: .http))
        // TODO: Finish implementation
        amqp = nil
        self.mqtt = nil
        self.jsonrpc = nil
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if http is HttpWithBodyRequestProtocol {
            try container.encode(http as? HttpWithBodyRequestProtocol, forKey: .http)
        } else if http is HttpParameter {
            try container.encode(http as? HttpParameter, forKey: .http)
        } else if http is HttpResponse {
            try container.encode(http as? HttpResponse, forKey: .http)
        } else if http is HttpModel {
            try container.encode(http as? HttpModel, forKey: .http)
        }
        // TODO: Finish implementation
    }
}
