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
    case byteArray
    case base64ByteArray
    case date
    case dateTime
    case `default`
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

    /**
        Create a ViewModel with a Key and Value pair

        - Parameter param: The parameter for the KeyValue Pair.  The serialized Name will be used as the key.
                    If the parameter is a Constant Schema, the value pf the VM will be the value of the Constant Schema
                     If not, it will check if the parameter is the signaure parameter of the operation If yes,
                    the value of the VM will be the name of the signature parameter.
        - Parameter operation: the operation which this paramter exists.
     */
    init(from param: ParameterType, with operation: Operation) {
        if let constantSchema = param.schema as? ConstantSchema {
            self.init(param: param, constantSchema: constantSchema)
        } else if let signatureParameter = operation.signatureParameter(for: param.name) {
            self.init(signatureParameter: signatureParameter)
        } else if let groupedBy = param.groupedBy?.name {
            self.init(key: param.name, value: "\(groupedBy).\(param.name)")
        } else if param.implementation == .client {
            let name = param.name.lowercasedFirst
            self.init(
                key: name,
                // if the parameter is $host, retrieve the value from client's 'endpoint' property
                value: (name == "$host") ? "endpoint.absoluteString" : name,
                optional: !param.required,
                path: "client."
            )
        } else {
            self.init(key: param.name, value: "?????")
        }
    }

    private init(param: ParameterType, constantSchema: ConstantSchema) {
        self.optional = false
        self.needDecodingInMethod = false
        self.path = ""
        self.key = param.serializedName ?? param.name
        let constantValue: String = constantSchema.value.value
        self.strategy = KeyValueDecodeStrategy.default.rawValue
        let type = constantSchema.valueType.type

        if type == .string,
            param.value.isSkipUrlEncoding {
            self.value = "\"\(constantValue)\".removingPercentEncoding ?? \"\""
        } else {
            switch type {
            case .date,
                 .unixTime,
                 .dateTime,
                 .byteArray,
                 .string:
                self.value = "\"\(constantValue)\""
            case .number:
                let numberSchema = constantSchema.valueType
                let swiftType = numberSchema.swiftType()
                if swiftType == "Decimal" {
                    self.value = "\(swiftType)(\(constantValue))"
                } else {
                    self.value = "String(\(swiftType)(\(constantValue)))"
                }
            default:
                self.value = "String(\(constantValue))"
            }
        }
    }

    private init(signatureParameter: ParameterType) {
        self.key = signatureParameter.serializedName ?? signatureParameter.name
        self.path = signatureParameter.belongsInOptions() ? "options?." : ""
        self.optional = !signatureParameter.required
        self.needDecodingInMethod = signatureParameter.required
        var keyValueType = KeyValueDecodeStrategy.default
        let type = signatureParameter.schema.type

        // value is referring a signature parameter, no need to wrap as String
        self.value = KeyValueViewModel.formatValue(
            forSignatureParameter: signatureParameter,
            value: signatureParameter.name
        )

        // if parameter is from method signature (not from option) and type is date or byteArray,
        // add decoding logic to string in the method and specify the right decoding strategy
        switch type {
        case .date,
             .unixTime:
            keyValueType = .date
        case .dateTime:
            keyValueType = .dateTime
        case .byteArray:
            if let byteArraySchema = signatureParameter.schema as? ByteArraySchema,
                byteArraySchema.format == .base64url {
                keyValueType = .base64ByteArray
            } else {
                keyValueType = .byteArray
            }
        default:
            keyValueType = .default
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
    init(key: String, value: String, optional: Bool = false, path: String = "") {
        self.key = key
        self.value = value
        self.optional = optional
        self.path = path
        self.strategy = KeyValueDecodeStrategy.default.rawValue
        self.needDecodingInMethod = false
    }

    /**
     Convert the type into String format in Swift
     */
    private static func formatValue(forSignatureParameter signatureParameter: ParameterType, value: String) -> String {
        let type = signatureParameter.schema.type
        switch type {
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
            return "\(value).map { String($0) }.joined(separator: \"\(signatureParameter.delimiter)\") "
        case .duration:
            return "DateComponentsFormatter().string(from: \(value)) ?? \"\""
        default:
            return "\(value)"
        }
    }

    static func < (lhs: KeyValueViewModel, rhs: KeyValueViewModel) -> Bool {
        return lhs.key < rhs.key
    }
}
