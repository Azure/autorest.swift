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

public enum ApiVersionRange: String, Codable {
    case plus = "+"
    case minus = "-"
}

// Since API version formats range from Azure ARM API date style (2018-01-01) to semver (1.2.3) and virtually
// any other text, this value tends to be an opaque string with the possibility of a modifier to indicate that it
// is a range.
// options:
// - prepend a dash or append a plus to indicate a range (ie, '2018-01-01+' or '-2019-01-01', or '1.0+' )
// - semver-range style (ie, '^1.0.0' or '~1.0.0' )
public class ApiVersion: Codable {
    /// The actual API version string used in the API
    let version: String

    let range: ApiVersionRange?

    enum CodingKeys: String, CodingKey {
        case version, range
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        range = try? container.decode(ApiVersionRange?.self, forKey: .range)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        if range != nil { try? container.encode(range, forKey: .range) }
    }
}
