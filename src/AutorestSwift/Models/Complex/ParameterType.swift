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

    var variableName: String {
        return common.variableName
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

    /**
     Convert the type into String format in Swift
     */
    public func formatValue(value: String) -> String {
        let type = schema.type
        switch type {
        case .integer,
             .boolean,
             .number:
            return "String(\(value))"
        // For these types, a variable will be created in the method using the naming convention `{key|value}String`
        case .date,
             .unixTime,
             .dateTime,
             .byteArray:
            return "\(value)String"
        case .choice,
             .sealedChoice:
            return "\(value).rawValue"
        case .array:
            return "\(value).map { String($0) }.joined(separator: \"\(delimiter)\") "
        case .duration:
            return "DateComponentsFormatter().string(from: \(value)) ?? \"\""
        default:
            return "\(value)"
        }
    }

    var keyValueDecodeStrategy: KeyValueDecodeStrategy {
        let type = schema.type
        // if parameter is from method signature (not from option) and type is date or byteArray,
        // add decoding logic to string in the method and specify the right decoding strategy
        switch type {
        case .date,
             .unixTime:
            return .date
        case .dateTime:
            return .dateTime
        case .byteArray:
            if let byteArraySchema = schema as? ByteArraySchema,
                byteArraySchema.format == .base64url {
                return .base64ByteArray
            } else {
                return .byteArray
            }
        case .number:
            if let numberSchema = schema as? NumberSchema {
                return (numberSchema.swiftType() == "Decimal") ? .decimal : .number
            } else {
                return .number
            }
        default:
            return .default
        }
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
        return first { $0.name == named }
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
