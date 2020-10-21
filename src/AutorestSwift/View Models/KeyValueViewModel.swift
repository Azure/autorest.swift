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

enum KeyValueDecodeStrategy: String {
    case dateFromParam
    case dateFromSignature
    case byteArrayFromParam
    case byteArrayFromSignature
    case `default`
    case dateTimeFromSignature
    case dateTimeFromParam
}

enum ValueSource: String {
    case options
    case clientProperty
    case signature
    case constant
}

/// View Model for a key-value pair, as used in Dictionaries.
/// Example:
///     "key" = value
struct KeyValueViewModel: Comparable {
    /// key of the Key-Value pair
    let key: String
    /// value of the Key-Value pair
    let value: String
    // Flag indicates if value is optional
    let optional: Bool
    // Flag indicates if the key/value pair need decoding code in method to convert the variable into a String
    let needDecodingInMethod: Bool
    // An enum raw value indicates what kind of decoding strategy will be used in the method implementation
    let strategy: String
    // The full path to the value property
    let path: String
    // An enum raw value indicates the source of the valur property
    let source: String

    /**
        Create a ViewModel with a Key and Value pair

        - Parameter param: The parameter for the KeyValue Pair.  The serialized Name will be used as the key.
                    If the parameter is a Constant Schema, the value pf the VM will be the value of the Constant Schema
                     If not, it will check if the parameter is the signaure parameter of the operation If yes,
                    the value of the VM will be the name of the signature parameter.
        - Parameter operation: the operation which this paramter exists.
     */
    init(from param: ParameterType, with operation: Operation) {
        let name = param.serializedName ?? param.name

        if let constantSchema = param.schema as? ConstantSchema {
            self.init(param: param, constantSchema: constantSchema, name: name)
        } else if let signatureParameter = operation.signatureParameter(for: name) {
            self.init(signatureParameter: signatureParameter, name: name)
        } else if let groupedBy = param.groupedBy?.name {
            self.init(key: name, value: "\(groupedBy).\(name)")
        } else if param.implementation == .client {
            self.init(
                key: name,
                value: name,
                optional: !param.required,
                path: "client.",
                source: .clientProperty
            )
        } else {
            self.init(key: name, value: "")
        }
    }

    private init(param: ParameterType, constantSchema: ConstantSchema, name: String) {
        self.optional = false
        self.path = ""
        self.source = ValueSource.constant.rawValue
        self.key = name
        let constantValue: String = constantSchema.value.value
        var keyValueType = KeyValueDecodeStrategy.default
        let type = constantSchema.valueType.type

        if type == .string {
            if param.value.isSkipUrlEncoding {
                self.value = "\"\(constantValue)\".removingPercentEncoding ?? \"\""
            } else {
                self.value = "\"\(constantValue)\""
            }
            self.needDecodingInMethod = false
        } else {
            self.needDecodingInMethod = param.implementation == ImplementationLocation.method
            switch type {
            case .date,
                 .unixTime:
                self.value = "\"\(constantValue)\""
                keyValueType = .dateFromParam
            case .dateTime:
                self.value = "\"\(constantValue)\""
                keyValueType = .dateTimeFromParam
            case .byteArray:
                self.value = "\"\(constantValue)\""
                keyValueType = .byteArrayFromParam
            case .number:
                self.value = "String(Double(\(constantValue)))"
            default:
                self.value = "String(\(constantValue))"
            }
        }
        self.strategy = keyValueType.rawValue
    }

    private init(signatureParameter: ParameterType, name: String) {
        self.key = name
        self.path = signatureParameter.belongsInOptions() ? "options." : ""
        self.source = signatureParameter.belongsInOptions() ? ValueSource.options.rawValue : ValueSource.signature
            .rawValue
        self.optional = !signatureParameter.required
        var keyValueType = KeyValueDecodeStrategy.default
        let type = signatureParameter.schema.type

        // value is referring a signature parameter, no need to wrap as String
        self.value = KeyValueViewModel.formatValueForType(
            type: type,
            value: name
        )

        // if parameter is from method signature (not from option) and type is date or byteArray,
        // add decoding logic to string in the method and specify the right decoding strategy
        switch type {
        case .date,
             .unixTime:
            keyValueType = signatureParameter.required ? .dateFromSignature : .dateFromParam
            self.needDecodingInMethod = true
        case .dateTime:
            keyValueType = signatureParameter.required ? .dateTimeFromSignature : .dateTimeFromParam
            self.needDecodingInMethod = true
        case .byteArray:
            keyValueType = signatureParameter.required ? .byteArrayFromSignature : .byteArrayFromParam
            self.needDecodingInMethod = true
        default:
            self.needDecodingInMethod = false
        }
        self.strategy = keyValueType.rawValue
    }

    /**
        Create a ViewModel with a Key and Value pair
        - Parameter key: Key String in the Key value pair
        - Parameter value: the value string
        - Parameter optional: a flag indicates if the Key/Value pair is optional
        - Parameter path: the full path to the value property
     */
    init(key: String, value: String, optional: Bool = false, path: String = "", source: ValueSource = .constant) {
        self.key = key
        self.value = value
        self.optional = optional
        self.path = path
        self.source = source.rawValue
        self.strategy = KeyValueDecodeStrategy.default.rawValue
        self.needDecodingInMethod = false
    }

    /**
     Convert the type into String format in Swift
     */
    private static func formatValueForType(type: AllSchemaTypes, value: String) -> String {
        switch type {
        case .string:
            return "\(value)"
        case .integer,
             .number,
             .boolean:
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
            return "\(value).map { String($0) }.joined(separator: \",\") "
        default:
            return "\(value)"
        }
    }

    static func < (lhs: KeyValueViewModel, rhs: KeyValueViewModel) -> Bool {
        return lhs.key < rhs.key
    }
}
