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

/// View Model for a key-value pair, as used in Dictionaries.
/// Example:
///     "key" = value
struct KeyValueViewModel {
    /// key of the Key-Value pair
    let key: String
    /// value of the Key-Value pair
    let value: String
    /// nane of the parameter where the 'value' is retrieved from.
    let paramName: String?
    // Flag indicates if value is optional
    let optional: Bool

    /**
        Create a ViewModel with a Key and Value pair

        - Parameter param: The parameter for the KeyValue Pair.  The serialized Name will be used as the key.
                    If the parameter is a Constant Schema, the value pf the VM will be the value of the Constant Schema
                     If not, it will check if the parameter is the signaure parameter of the operation If yes,
                    the value of the VM will be the name of the signature parameter.
        - Parameter operation: the operation which this paramter exists.
     */
    init(from param: ParameterType, with operation: Operation) {
        self.key = param.serializedName ?? param.name

        if let constantSchema = param.schema as? ConstantSchema {
            let isString: Bool = constantSchema.valueType.type == AllSchemaTypes.string
            let val: String = constantSchema.value.value

            self.value = isString ? "\"\(val)\"" : "\(val)"
            self.optional = false
            self.paramName = nil
        } else if let signatureParameter = operation.signatureParameter(for: param.name) {
            // value is referring a signautre parameter, no need to wrap as String
            self.paramName = param.name
            self.optional = !signatureParameter.required
            let swiftType = signatureParameter.schema.swiftType(optional: optional)
            if swiftType.starts(with: "String") {
                self.value = param.name
            } else if swiftType.starts(with: "Date") {
                self.value = "String(describing:\(param.name), format: Date.Format.iso8601)"
            } else {
                // Convert into String in generated code
                self.value = "String(\(param.name))"
            }
        } else {
            self.value = ""
            self.optional = false
            self.paramName = nil
        }
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
        self.paramName = nil
    }
}
