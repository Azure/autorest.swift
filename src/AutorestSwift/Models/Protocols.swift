//
//  Protocols.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public class Protocols: Codable {
    public let http: ProtocolInterface?

    public let amqp: ProtocolInterface?

    public let mqtt: ProtocolInterface?

    public let jsonrpc: ProtocolInterface?

    enum CodingKeys: String, CodingKey {
        case http, amqp, mqtt, jsonrpc
    }

    // MARK: Codable

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        http = (try? container.decode(HttpWithBodyRequest.self, forKey: .http)) ??
            (try? container.decode(HttpRequest.self, forKey: .http)) ??
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

        if http is HttpWithBodyRequest {
            try container.encode(http as? HttpWithBodyRequest, forKey: .http)
        } else if http is HttpParameter {
            try container.encode(http as? HttpParameter, forKey: .http)
        } else if http is HttpResponse {
            try container.encode(http as? HttpResponse, forKey: .http)
        } else if http is HttpModel {
            try container.encode(http as? HttpModel, forKey: .http)
        } else if http is HttpRequest {
            try container.encode(http as? HttpRequest, forKey: .http)
        }

        // TODO: Finish implementation
    }
}
