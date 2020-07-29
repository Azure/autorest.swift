// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation

/// Custom extensible metadata for individual protocols (ie, HTTP, etc)
public class Protocols: Codable {
    let http: ProtocolInterface?

    let amqp: ProtocolInterface?

    let mqtt: ProtocolInterface?

    let jsonrpc: ProtocolInterface?

    enum CodingKeys: String, CodingKey {
        case http, amqp, mqtt, jsonrpc
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
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
