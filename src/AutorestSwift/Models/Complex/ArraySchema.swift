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

class ArraySchema: Schema {
    /// elementType of the array
    let elementType: Schema!

    /// maximum number of elements in the array
    let maxItems: Int?

    /// minimum number of elements in the array
    let minItems: Int?

    /// if the elements in the array should be unique
    let uniqueItems: Bool?

    /// if elements in the array should be nullable
    let nullableItems: Bool?

    enum CodingKeys: String, CodingKey {
        case elementType, maxItems, minItems, uniqueItems, nullableItems
    }

    // MARK: Codable

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.elementType = try Schema.decode(withContainer: container, useKey: "elementType")
        self.maxItems = try? container.decode(Int.self, forKey: .maxItems)
        self.minItems = try? container.decode(Int.self, forKey: .minItems)
        self.uniqueItems = try? container.decode(Bool.self, forKey: .uniqueItems)
        self.nullableItems = try? container.decode(Bool.self, forKey: .nullableItems)

        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(elementType, forKey: .elementType)
        if maxItems != nil { try container.encode(maxItems, forKey: .maxItems) }
        if minItems != nil { try container.encode(minItems, forKey: .minItems) }
        if uniqueItems != nil { try container.encode(uniqueItems, forKey: .uniqueItems) }
        if nullableItems != nil { try container.encode(nullableItems, forKey: .nullableItems) }

        try super.encode(to: encoder)
    }
}
