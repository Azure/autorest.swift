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

public class ArraySchema: Schema {
    /// elementType of the array
    public let elementType: Schema

    /// maximum number of elements in the array
    public let maxItems: Int?

    /// minimum number of elements in the array
    public let minItems: Int?

    /// if the elements in the array should be unique
    public let uniqueItems: Bool?

    /// if elements in the array should be nullable
    public let nullableItems: Bool?

    enum CodingKeys: String, CodingKey {
        case elementType, maxItems, minItems, uniqueItems, nullableItems
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let objectSchema = try? container.decode(ObjectSchema.self, forKey: .elementType) {
            self.elementType = objectSchema
        } else {
            self.elementType = try container.decode(Schema.self, forKey: .elementType)
        }
        self.maxItems = try? container.decode(Int.self, forKey: .maxItems)
        self.minItems = try? container.decode(Int.self, forKey: .minItems)
        self.uniqueItems = try? container.decode(Bool.self, forKey: .uniqueItems)
        self.nullableItems = try? container.decode(Bool.self, forKey: .nullableItems)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(elementType, forKey: .elementType)
        if maxItems != nil { try container.encode(maxItems, forKey: .maxItems) }
        if minItems != nil { try container.encode(minItems, forKey: .minItems) }
        if uniqueItems != nil { try container.encode(uniqueItems, forKey: .uniqueItems) }
        if nullableItems != nil { try container.encode(nullableItems, forKey: .nullableItems) }

        try super.encode(to: encoder)
    }
}
