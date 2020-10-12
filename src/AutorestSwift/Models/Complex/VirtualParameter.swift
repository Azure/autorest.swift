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
class VirtualParameter: Parameter {
    /// the original body parameter that this parameter is in effect replacing
    let originalParameter: Parameter

    /// if this parameter is for a nested property, this is the path of properties it takes to get there
    let pathToProperty: [Property]

    /// the target property this virtual parameter represents
    let targetProperty: Property

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case originalParameter, pathToProperty, targetProperty
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        originalParameter = try container.decode(Parameter.self, forKey: .originalParameter)
        pathToProperty = try container.decode([Property].self, forKey: .pathToProperty)
        targetProperty = try container.decode(Property.self, forKey: .targetProperty)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(originalParameter, forKey: .originalParameter)
        try container.encode(pathToProperty, forKey: .pathToProperty)
        try container.encode(targetProperty, forKey: .targetProperty)

        try super.encode(to: encoder)
    }

    override internal func belongsInSignature() -> Bool {
        // We track body params in a special way, so always omit them generally from the signature.
        // If they belong in the signature, they will be added in a way to ensure they come first.
        guard paramLocation != .body else { return false }

        // Default logic
        let inMethod = implementation == .method
        let notConstant = schema?.type != .constant
        let notGrouped = groupedBy == nil
        return inMethod && notConstant && notGrouped
    }

    override internal func belongsInOptions() -> Bool {
        let inMethod = implementation == .method
        let notConstant = schema?.type != .constant
        let notFlattened = flattened != true
        let notGrouped = groupedBy == nil
        return inMethod && notConstant && notFlattened && notGrouped
    }
}
