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

/// a schema that represents a Number value
class NumberSchema: PrimitiveSchema {
    /// precision (# of bits?) of the number
    let precision: Int

    /// if present, the number must be an exact multiple of this value
    let multipleOf: Int?

    /// if present, the value must be lower than or equal to this (unless exclusiveMaximum is true)
    let maximum: Int?

    /// if present, the value must be lower than maximum
    let exclusiveMaximum: Bool?

    /// if present, the value must be highter than or equal to this (unless exclusiveMinimum is true)
    let minimum: Int?

    /// if present, the value must be higher than minimum
    let exclusiveMinimum: Bool?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case precision, multipleOf, maximum, exclusiveMaximum, minimum, exclusiveMinimum
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        precision = try container.decode(Int.self, forKey: .precision)
        multipleOf = try? container.decode(Int.self, forKey: .multipleOf)
        maximum = try? container.decode(Int.self, forKey: .maximum)
        exclusiveMaximum = try? container.decode(
            Bool.self,
            forKey:
            .exclusiveMaximum
        )

        minimum = try? container.decode(Int.self, forKey: .minimum)
        exclusiveMinimum = try? container.decode(Bool.self, forKey: .exclusiveMinimum)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(precision, forKey: .precision)
        if multipleOf != nil { try container.encode(multipleOf, forKey: .multipleOf) }
        if maximum != nil { try container.encode(maximum, forKey: .maximum) }
        if exclusiveMaximum != nil { try container.encode(exclusiveMaximum, forKey: .exclusiveMaximum) }
        if minimum != nil { try container.encode(minimum, forKey: .minimum) }
        if exclusiveMinimum != nil { try container.encode(exclusiveMinimum, forKey: .exclusiveMinimum) }

        try super.encode(to: encoder)
    }

    override func swiftType(optional _: Bool = false) -> String {
        switch precision {
        case 32:
            return (type == .integer) ? "Int32" : "Float"
        case 64:
            return (type == .integer) ? "Int64" : "Double"
        case 128:
            return (type == .integer) ? "Int" : "Decimal"
        default:
            return (type == .integer) ? "Int" : "Double"
        }
    }
}
