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

class HttpWithBodyRequest: HttpRequest {
    // canonical response type (ie, 'json')
    let knownMediaType: KnownMediaType

    // content returned by the service in the HTTP headers
    let mediaTypes: [String]

    // content returned by the service in the HTTP headers
    let headers: [HttpHeader]?

    // sets of HTTP headers grouped together into a single schema
    let headerGroups: [GroupSchema]?

    enum CodingKeys: String, CodingKey {
        case knownMediaType, mediaTypes, headers, headerGroups
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        knownMediaType = try container.decode(KnownMediaType.self, forKey: .knownMediaType)
        mediaTypes = try container.decode([String].self, forKey: .mediaTypes)
        headers = try? container.decode([HttpHeader].self, forKey: .headers)
        headerGroups = try? container.decode([GroupSchema].self, forKey: .headerGroups)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(knownMediaType, forKey: .knownMediaType)
        try container.encode(mediaTypes, forKey: .mediaTypes)

        if headers != nil { try container.encode(headers, forKey: .headers) }
        if headerGroups != nil { try container.encode(headerGroups, forKey: .headerGroups) }

        try super.encode(to: encoder)
    }
}
