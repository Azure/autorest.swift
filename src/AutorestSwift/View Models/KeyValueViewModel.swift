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
    case dateTimeIso8601
    case dateTimeRfc1123
    case `default`
    case decimal
    case number
    case unixTime
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
            let name = param.variableName
            self.init(
                key: name,
                // if the parameter is $host, retrieve the value from client's 'endpoint' property
                value: (name == "$host") ? "endpoint.absoluteString" : param.formatValue(name),
                optional: !param.required,
                path: "client."
            )
        } else if param.paramLocation == .body {
            let bodyParamName = operation.request?.bodyParamName(for: operation)
            self.init(bodySignatureParameter: param, bodyParamName: bodyParamName)
        } else {
            assertionFailure("Not expected to have the scenario in KeyValue ViewModel")
            self.init(key: param.name, value: "")
        }
    }

    private init(signatureParameter: ParameterType) {
        assert(!(signatureParameter.serializedName?.isEmpty ?? true))
        self.key = signatureParameter.serializedName ?? ""
        self.path = signatureParameter.belongsInOptions() ? "options?." : ""
        self.optional = !signatureParameter.required
        self.needDecodingInMethod = signatureParameter.required

        // value is referring a signature parameter, no need to wrap as String
        self.value = signatureParameter.formatValue()
        self.strategy = signatureParameter.keyValueDecodeStrategy.rawValue
    }

    private init(param: ParameterType, constantSchema: ConstantSchema) {
        self.optional = false
        self.needDecodingInMethod = false
        self.path = ""
        self.value = constantSchema.formatValue(skipUrlEncoding: param.value.isSkipUrlEncoding)

        if param.paramLocation == .header {
            assert(!(param.serializedName?.isEmpty ?? true))
            self.key = param.serializedName ?? ""
        } else if param.paramLocation == .body {
            self.key = value
        } else {
            self.key = param.name
        }
        self.strategy = KeyValueDecodeStrategy.default.rawValue
    }

    private init(bodySignatureParameter: ParameterType, bodyParamName: String?) {
        self.path = bodySignatureParameter.belongsInOptions() ? "options?." : ""
        self.optional = !bodySignatureParameter.required

        self.strategy = bodySignatureParameter.keyValueDecodeStrategy.rawValue

        var needDecodingInMethod = bodySignatureParameter
            .keyValueDecodeStrategy != .default
        let type = bodySignatureParameter.schema.type

        self.key = bodyParamName ?? bodySignatureParameter.name

        if type == .byteArray || type == .unixTime,
            bodySignatureParameter.paramLocation == .body {
            needDecodingInMethod = false
        }

        // value is referring a signature parameter, no need to wrap as String
        if let bodyParamName1 = bodyParamName {
            self.value = needDecodingInMethod ? "\(bodyParamName1)String" : bodyParamName1
        } else {
            self.value = bodySignatureParameter.formatValue(bodyParamName)
        }

        self.needDecodingInMethod = needDecodingInMethod
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

    static func < (lhs: KeyValueViewModel, rhs: KeyValueViewModel) -> Bool {
        return lhs.key < rhs.key
    }
}
