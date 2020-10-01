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

/// a schema that represents a constant value
class ConstantSchema: Schema {
    /// a container for the actual constant value
    class ConstantValue: Codable, OptionalLanguageShortcut {
        /// per-language information for this value
        public var language: Languages?

        /// the actual constant value to use
        let value: String

        /// Additional metadata extensions dictionary
        let extensions: [String: AnyCodable]?

        enum CodingKeys: String, CodingKey {
            case language, value, extensions
        }

        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            language = try? container.decode(Languages?.self, forKey: .language)
            value = try container.decode(String.self, forKey: .value)
            extensions = try? container.decode([String: AnyCodable].self, forKey: .extensions)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            if language != nil { try? container.encode(language, forKey: .language) }
            try container.encode(value, forKey: .value)
            if extensions != nil { try container.encode(extensions, forKey: .extensions) }
        }
    }

    /// the schema type of the constant value (ie, StringSchema, NumberSchema, etc)
    let valueType: Schema

    /// the constant value
    let value: ConstantValue

    enum CodingKeys: String, CodingKey {
        case valueType, value
    }

    enum ValueCodingKeys: String, CodingKey {
        case value
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        valueType = try Schema.decode(withContainer: container, useKey: "valueType") ?? container
            .decode(Schema.self, forKey: .valueType)
        value = try container.decode(ConstantValue.self, forKey: .value)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(valueType, forKey: .valueType)

        var valueContainer = container
            .nestedContainer(keyedBy: ValueCodingKeys.self, forKey: .value)

        switch valueType.type {
        case .boolean:
            try valueContainer.encode(Bool(value.value), forKey: .value)
        case .integer:
            try valueContainer.encode(Int(value.value), forKey: .value)
        case .number:
            if let numberSchema = valueType as? NumberSchema {
                if numberSchema.precision >= 32 {
                    try valueContainer.encode(Double(value.value), forKey: .value)
                } else {
                    try valueContainer.encode(value.value, forKey: .value)
                }
            } else {
                try valueContainer.encode(Double(value.value), forKey: .value)
            }
        default:
            try valueContainer.encode(value.value, forKey: .value)
        }

        try super.encode(to: encoder)
    }
}
