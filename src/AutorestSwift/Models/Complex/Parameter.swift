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

/// A definition of an discrete input for an operation
class Parameter: Value, CustomDebugStringConvertible {
    /// suggested implementation location for this parameter
    let implementation: ImplementationLocation?

    /// When a parameter is flattened, it will be left in the list, but marked hidden (so, don't generate those!)
    let flattened: Bool?

    /// when a parameter is grouped into another, this will tell where the parameter got grouped into
    let groupedBy: Parameter?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case implementation, flattened, schema, groupedBy
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        implementation = try? container.decode(ImplementationLocation.self, forKey: .implementation)
        flattened = try? container.decode(Bool.self, forKey: .flattened)
        groupedBy = try? container.decode(Parameter.self, forKey: .groupedBy)

        try super.init(from: decoder)

        if let constantSchema = try? container.decode(ConstantSchema.self, forKey: .schema) {
            super.schema = constantSchema
        } else if let numberSchema = try? container.decode(NumberSchema.self, forKey: .schema) {
            super.schema = numberSchema
        } else if let objectSchema = try? container.decode(ObjectSchema.self, forKey: .schema) {
            super.schema = objectSchema
        } else {
            super.schema = try container.decode(Schema.self, forKey: .schema)
        }
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if implementation != nil { try container.encode(implementation, forKey: .implementation) }
        if flattened != nil { try container.encode(flattened, forKey: .flattened) }

        try super.encode(to: encoder)
    }

    // MARK: CustomDebugStringConvertible

    public var debugDescription: String {
        return debugString() ?? description
    }
}
