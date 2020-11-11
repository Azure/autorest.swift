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

    var implementation: ImplementationLocation? {
        return common.implementation
    }

    var paramLocation: ParameterLocation? {
        return common.paramLocation
    }

    var style: SerializationStyle? {
        return common.style
    }

    var delimiter: String {
        return common.delimiter
    }

    var clientDefaultValue: String? {
        return common.clientDefaultValue
    }

    var flattened: Bool {
        return common.flattened ?? false
    }

    var groupedBy: Parameter? {
        return common.groupedBy
    }

    var nullable: Bool {
        return common.nullable ?? false
    }

    var isConstantSchema: Bool {
        return common.schema as? ConstantSchema != nil
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

    internal func belongsInSignature() -> Bool {
        return common.belongsInSignature()
    }

    internal func belongsInOptions() -> Bool {
        return common.belongsInOptions()
    }
}

extension ParameterType: Equatable {
    static func == (lhs: ParameterType, rhs: ParameterType) -> Bool {
        switch lhs {
        case let .regular(lparam):
            if case let ParameterType.regular(rparam) = rhs {
                return lparam == rparam
            }
        case let .virtual(lparam):
            if case let ParameterType.virtual(rparam) = rhs {
                return lparam == rparam
            }
        }
        return false
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

    /// Returns the subset of `ParameterType` that are `VirtualParameter` types.
    var virtual: [VirtualParameter] {
        return compactMap { param in
            if case let ParameterType.virtual(virtParam) = param {
                return virtParam
            }
            return nil
        }
    }

    /// Returns the required items that should be in the method signature
    var inSignature: [ParameterType] {
        return filter { $0.belongsInSignature() }
    }

    /// Returns the optional items that should be in the method's Options object
    var inOptions: [ParameterType] {
        return filter { $0.belongsInOptions() }
    }

    var inQuery: [ParameterType] {
        return filter { param in
            guard param.implementation == ImplementationLocation.method,
                param.schema.type != .constant
            else { return false }
            return param.located(in: .query)
        }
    }

    /// Returns the items that should be passed in the request header
    var inHeader: [ParameterType] {
        return filter { param in
            guard param.implementation == ImplementationLocation.method,
                param.schema.type != .constant
            else { return false }
            return param.located(in: .header)
        }
    }

    /// Returns the items that should be passed in the path
    var inPath: [ParameterType] {
        return filter { param in
            guard param.implementation == ImplementationLocation.method,
                param.schema.type != .constant
            else { return false }
            return param.located(in: .path)
        }
    }
}
