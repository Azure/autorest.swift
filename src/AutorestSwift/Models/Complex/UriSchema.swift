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

// public typealias UriSchema = Compose<UriSchemaProperty, PrimitiveSchema>

/// a schema that represents a Uri value
public class UriSchema: PrimitiveSchema {
    /// the maximum length of the string
    let maxLength: Int?

    /// the minimum length of the string
    let minLength: Int?

    /// a regular expression that the string must be validated against
    let pattern: String?

    enum CodingKeys: String, CodingKey {
        case maxLength, minLength, pattern
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        maxLength = try? container.decode(Int?.self, forKey: .maxLength)
        minLength = try? container.decode(Int?.self, forKey: .minLength)
        pattern = try? container.decode(String?.self, forKey: .pattern)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if maxLength != nil { try? container.encode(maxLength, forKey: .maxLength) }
        if minLength != nil { try? container.encode(minLength, forKey: .minLength) }
        if pattern != nil { try? container.encode(pattern, forKey: .pattern) }
        try super.encode(to: encoder)
    }
}
