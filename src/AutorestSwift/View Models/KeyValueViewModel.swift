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

enum KeyValueType: String {
    case dateFromConstant
    case byteArrayFromConstant
    case `default`
    case dateFromSignature
    case byteArrayFromSignature
}

/// View Model for a key-value pair, as used in Dictionaries.
/// Example:
///     "key" = value
struct KeyValueViewModel {
    /// key of the Key-Value pair
    let key: String
    /// value of the Key-Value pair
    let value: String

    // Flag indicates if value is optional
    let optional: Bool

    let strategy: String
    let implementedInMethod: Bool
    let constantValue: String?

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

        var keyValueType = KeyValueType.default

        if let constantSchema = param.schema as? ConstantSchema {
            self.optional = false
            self.implementedInMethod = param.implementation == ImplementationLocation.method

            let constantValue: String = constantSchema.value.value
            let value = convertValueToStringInSwift(
                type: constantSchema.valueType.type,
                value: constantValue,
                key: name
            )

            switch constantSchema.valueType.type {
            case .string:
                self.value = "\(value)"
                self.constantValue = "\"\(constantValue)\""
            case .date,
                 .dateTime,
                 .unixTime:
                self.value = "\(value)"
                self.constantValue = "\"\(constantValue)\""
                keyValueType = .dateFromConstant
            case .byteArray:
                self.value = "\(value)"
                self.constantValue = "\"\(constantValue)\""
                keyValueType = .byteArrayFromConstant
            case .number:
                self.value = "\(value)"
                self.constantValue = "Double(\(constantValue))"
            default:
                self.value = "\(value)"
                self.constantValue = constantValue
            }
        } else if let signatureParameter = operation.signatureParameter(for: name) {
            self.optional = !signatureParameter.required
            self.constantValue = nil

            // value is referring a signature parameter, no need to wrap as String
            self.value = convertValueToStringInSwift(
                type: signatureParameter.schema.type,
                value: name
            )

            // if parameter is from method signature (not from option) and type is date or byteArray,
            // add decoding logic to string in the method and specify the right decoding strategy
            switch signatureParameter.schema.type {
            case .date,
                 .unixTime,
                 .dateTime:
                keyValueType = signatureParameter.required ? .dateFromSignature : .dateFromConstant
                self.implementedInMethod = true
            case .byteArray:
                keyValueType = signatureParameter.required ? .byteArrayFromSignature : .byteArrayFromConstant
                self.implementedInMethod = true
            default:
                self.implementedInMethod = false
            }
        } else if param.implementation == ImplementationLocation.client {
            self.value = "client.\(name)"
            self.optional = false
            self.implementedInMethod = false
            self.constantValue = nil
        } else {
            self.value = ""
            self.optional = false
            self.implementedInMethod = false
            self.constantValue = nil
        }

        self.key = name
        self.strategy = keyValueType.rawValue
    }

    /**
        Create a ViewModel with a Key and Value pair
        - Parameter key: Key String in the Key value pair
        - Parameter value: the value string
     */
    init(key: String, value: String) {
        self.key = key
        self.value = value
        self.optional = false

        self.strategy = KeyValueType.default.rawValue
        self.implementedInMethod = false
        self.constantValue = nil
    }
}

private func convertValueToStringInSwift(type: AllSchemaTypes, value: String, key: String? = nil) -> String {
    switch type {
    case AllSchemaTypes.string:
        return "\(key ?? value)"
    case AllSchemaTypes.integer,
         AllSchemaTypes.number:
        return "String(\(key ?? value))"
    case AllSchemaTypes.date,
         AllSchemaTypes.unixTime,
         AllSchemaTypes.dateTime:
        return "\(key ?? value)String"
    case AllSchemaTypes.choice,
         AllSchemaTypes.sealedChoice:
        return "\(value).rawValue"
    case AllSchemaTypes.boolean:
        return "String(\(key ?? value))"
    case AllSchemaTypes.array:
        return "\(value).map { String($0) }.joined(separator: \",\") "
    case AllSchemaTypes.byteArray:
        return "\(key ?? value)String"
    default:
        return "\(value)"
    }
}
