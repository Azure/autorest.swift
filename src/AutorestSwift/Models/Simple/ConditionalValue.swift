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

/// an individual value in a ConditionalSchema
public class ConditionalValue: Codable, LanguageShortcut {
    /// per-language information for this value
    public var language: Languages

    /// the actual value
    // TODO: Resolve issue with enum
    public let target: String // StringOrNumberOrBoolean

    /// the source value
    // TODO: Resolve issue with enum
    public let source: String // StringOrNumberOrBoolean

    /// Additional metadata extensions dictionary
    public let extensions: AnyCodable?

    enum CodingKeys: String, CodingKey {
        case language, target, source, extensions
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        language = try container.decode(Languages.self, forKey: .language)
        target = try container.decode(String.self, forKey: .target)
        source = try container.decode(String.self, forKey: .source)
        extensions = try? container.decode(AnyCodable.self, forKey: .extensions)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(language, forKey: .language)
        try container.encode(target, forKey: .target)
        try container.encode(source, forKey: .source)
        if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    }
}
