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

enum PropertyType: Codable {
    case regular(Property)
    case grouped(GroupProperty)

    // MARK: Codable

    init(from decoder: Decoder) throws {
        if let decoded = try? GroupProperty(from: decoder) {
            self = .grouped(decoded)
        } else if let decoded = try? Property(from: decoder) {
            self = .regular(decoded)
        } else {
            fatalError("Unable to decode PropertyType")
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case let .regular(param):
            try param.encode(to: encoder)
        case let .grouped(param):
            try param.encode(to: encoder)
        }
    }

    // MARK: Property Helpers

    var name: String {
        return common.name
    }

    var schema: Schema {
        return common.schema!
    }

    var value: Value {
        return common as Value
    }

    var required: Bool {
        return common.required
    }

    var description: String {
        return common.description
    }

    var serializedName: String? {
        return common.serializedName
    }

    var `protocol`: Protocols {
        return common.protocol
    }

    var clientDefaultValue: String? {
        return common.clientDefaultValue
    }

    var readOnly: Bool? {
        return common.readOnly
    }

    var flattenedNames: [String]? {
        return common.flattenedNames
    }

    var isDiscriminator: Bool? {
        return common.isDiscriminator
    }

    private var common: Property {
        switch self {
        case let .regular(reg):
            return reg
        case let .grouped(virt):
            return virt as GroupProperty
        }
    }

    // MARK: Methods

    /// Returns whether the given parameter is located in the specified location.
    internal func located(in location: ParameterLocation) -> Bool {
        if let httpParam = self.protocol.http as? HttpParameter {
            return httpParam.in == location
        } else {
            return false
        }
    }

    /// Returns whether the given parameter is located in any of the specified locations.
    internal func located(in locations: [ParameterLocation]) -> Bool {
        for location in locations {
            if located(in: location) {
                return true
            }
        }
        return false
    }
}

extension PropertyType: Equatable {
    static func == (lhs: PropertyType, rhs: PropertyType) -> Bool {
        switch lhs {
        case let .regular(lparam):
            if case let PropertyType.regular(rparam) = rhs {
                return lparam == rparam
            }
        case let .grouped(lparam):
            if case let PropertyType.grouped(rparam) = rhs {
                return lparam == rparam
            }
        }
        return false
    }
}

extension Array where Element == PropertyType {
    func first(named: String) -> Element? {
        for param in self {
            let name = param.serializedName ?? param.name
            if named == name {
                return param
            }
        }
        // no match found
        return nil
    }

    /// Returns the subset of `PropertyType` that are `GroupProperty` types.
    var grouped: [GroupProperty] {
        return compactMap { prop in
            if case let PropertyType.grouped(groupProp) = prop {
                return groupProp
            }
            return nil
        }
    }
}
