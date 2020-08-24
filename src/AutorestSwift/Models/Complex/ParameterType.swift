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

enum ParameterType: Codable {
    case regular(Parameter)
    case virtual(VirtualParameter)

    // MARK: Codable

    init(from decoder: Decoder) throws {
        if let decoded = try? VirtualParameter(from: decoder) {
            self = .virtual(decoded)
        } else if let decoded = try? Parameter(from: decoder) {
            self = .regular(decoded)
        } else {
            fatalError("Unable to decode ParameterType")
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case let .regular(param):
            try param.encode(to: encoder)
        case let .virtual(param):
            try param.encode(to: encoder)
        }
    }

    // MARK: Property Helpers

    var name: String {
        return common.name
    }

    var schema: Schema {
        return common.schema
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

    var implementation: ImplementationLocation? {
        return common.implementation
    }

    var clientDefaultValue: String? {
        return common.clientDefaultValue
    }

    var flattened: Bool {
        return common.flattened ?? false
    }

    /// Return the common base class Parameter properties
    private var common: Parameter {
        switch self {
        case let .regular(reg):
            return reg
        case let .virtual(virt):
            return virt as Parameter
        }
    }
}

extension Array where Element == ParameterType {
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
}
