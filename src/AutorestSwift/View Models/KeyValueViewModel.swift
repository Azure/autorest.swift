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
    case date
    case byteArray
    case none
    case sigDate
    case sigByteArray
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

    let keyValueType: String
    let implementedInMethod: Bool
    let defaultValue: String?

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

        var keyValueType = KeyValueType.none

        if let constantSchema = param.schema as? ConstantSchema {
            let val: String = constantSchema.value.value

            self.optional = false
            self.implementedInMethod = param.implementation == ImplementationLocation.method

            var value: String
            (value, keyValueType) = convertValueToStringInSwift(
                type: constantSchema.valueType.type,
                val: val,
                key: name
            )
            self.value = (constantSchema.valueType.type == AllSchemaTypes.string) ? "\"\(value)\"" : "\(value)"

            if (constantSchema.valueType.type == AllSchemaTypes.string) ||
                (constantSchema.valueType.type == AllSchemaTypes.date) ||
                (constantSchema.valueType.type == AllSchemaTypes.dateTime) ||
                (constantSchema.valueType.type == AllSchemaTypes.byteArray) {
                self.defaultValue = "\"\(constantSchema.value.value)\""
            } else {
                self.defaultValue = constantSchema.value.value
            }

        } else if let signatureParameter = operation.signatureParameter(for: name) {
            // value is referring a signautre parameter, no need to wrap as String

            self.optional = !signatureParameter.required

            (self.value, keyValueType) = convertValueToStringInSwift(
                type: signatureParameter.schema.type,
                val: name,
                key: name
            )
            self.defaultValue = nil
            if (signatureParameter.schema.type == AllSchemaTypes.date) ||
                (signatureParameter.schema.type == AllSchemaTypes.unixTime) ||
                (signatureParameter.schema.type == AllSchemaTypes.dateTime) {
                keyValueType = signatureParameter.required ? .sigDate : .date
                self.implementedInMethod = true
            } else if signatureParameter.schema.type == AllSchemaTypes.byteArray {
                keyValueType = signatureParameter.required ? .sigByteArray : .byteArray
                self.implementedInMethod = true
            } else {
                self.implementedInMethod = false
            }
        } else {
            self.value = ""
            self.optional = false
            self.implementedInMethod = false
            self.defaultValue = nil
        }

        self.key = name
        self.keyValueType = keyValueType.rawValue
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

        self.keyValueType = KeyValueType.none.rawValue
        self.implementedInMethod = false
        self.defaultValue = nil
    }
}

func convertValueToStringInSwift(type: AllSchemaTypes, val: String, key: String? = nil) -> (String, KeyValueType) {
    switch type {
    case AllSchemaTypes.string:
        return ("\(val)", .none)
    case AllSchemaTypes.integer,
         AllSchemaTypes.number:
        return ("String(\(val))", .none)
    case AllSchemaTypes.date,
         AllSchemaTypes.unixTime,
         AllSchemaTypes.dateTime:
        return ("\(key ?? val)String", .date)
    case AllSchemaTypes.choice,
         AllSchemaTypes.sealedChoice:
        return ("\(val).rawValue", .none)
    case AllSchemaTypes.boolean:
        return ("String(\(val))", .none)
    case AllSchemaTypes.array:
        return ("\(val).map { String($0) }.joined(separator: \",\") ", .none)
    case AllSchemaTypes.byteArray:
        return ("\(key ?? val)String", .byteArray)
    default:
        return ("\(val)", .none)
    }
}
