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

// a property is a child value in an object
class Property: Value {
    // if the property is marked read-only (ie, not intended to be sent to the service)
    let readOnly: Bool?

    // the wire name of this property
    let serializedName: String

    // when a property is flattened, the property will be the set of serialized names to  get to that target property.
    // If flattenedName is present, then this property is a flattened property. (ie, ['properties','name'] )
    let flattenedNames: [String]?

    // if this property is used as a discriminator for a polymorphic type
    let isDiscriminator: Bool?

    enum CodingKeys: String, CodingKey {
        case readOnly, serializedName, flattenedNames, isDiscriminator
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.readOnly = try? container.decode(Bool.self, forKey: .readOnly)
        self.serializedName = try container.decode(String.self, forKey: .serializedName)
        self.flattenedNames = try? container.decode([String].self, forKey: .flattenedNames)
        self.isDiscriminator = try? container.decode(Bool.self, forKey: .isDiscriminator)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if readOnly != nil { try container.encode(readOnly, forKey: .readOnly) }
        try container.encode(serializedName, forKey: .serializedName)
        if flattenedNames != nil { try container.encode(flattenedNames, forKey: .flattenedNames) }
        if isDiscriminator != nil { try container.encode(isDiscriminator, forKey: .isDiscriminator) }

        try super.encode(to: encoder)
    }
}
