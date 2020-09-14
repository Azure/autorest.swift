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

/// a response that should be deserialized into a result of type(schema)
class SchemaResponse: Response {
    /// the content returned by the service for a given operation
    let schema: Schema

    /// indicates whether the response can be 'null'
    let nullable: Bool?

    enum CodingKeys: String, CodingKey {
        case schema, nullable
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let schemaContainer = try container.nestedContainer(keyedBy: Schema.CodingKeys.self, forKey: .schema)
        let type = try? schemaContainer.decode(AllSchemaTypes.self, forKey: Schema.CodingKeys.type)

        var schema: Schema?
        switch type {
        case .array:
            schema = try? container.decode(ArraySchema.self, forKey: .schema)
        case .dictionary:
            schema = try? container.decode(DictionarySchema.self, forKey: .schema)
        case .object:
            schema = try? container.decode(ObjectSchema.self, forKey: .schema)
        default:
            schema = try container.decode(Schema.self, forKey: .schema)
        }

        self.schema = try schema ?? container.decode(Schema.self, forKey: .schema)
        self.nullable = try? container.decode(Bool.self, forKey: .nullable)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        if nullable != nil { try container.encode(nullable, forKey: .nullable) }

        try super.encode(to: encoder)
    }
}
