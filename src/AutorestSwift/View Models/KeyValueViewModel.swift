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

    case byeArray

    case none
}

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

    //  let type: AllSchemaTypes

    //   let needDecoderBlock: Bool
    let keyValueType: String
    let implementedInMethod: Bool
    // let isDate: Bool
    // let isByteArray: Bool
    // var fromOption: Bool
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
        self.key = name
        //    var needDecoderBlock = false
        var keyValueType = KeyValueType.none
        /*
         if param.implementation == ImplementationLocation.method {
             if let constantSchema = param.schema as? ConstantSchema {
                 self.type = constantSchema.valueType.type
                 let value = key // method variable name
                 self.value = convertValueToStringInSwift(type: constantSchema.valueType.type, val: value)
                 self.optional = false
                 self.paramName = nil
                 self.isDate = constantSchema.valueType.type == AllSchemaTypes.date || constantSchema.valueType
                     .type == AllSchemaTypes.dateTime
                 self.isByteArray = constantSchema.valueType.type == AllSchemaTypes.byteArray
             } else {
                 self.value = convertValueToStringInSwift(type: param.schema.type, val: key) // pull from option object
                 self.optional = true
                 self.paramName = key
                 self.type = param.schema.type
                 self.isDate = param.schema.type == AllSchemaTypes.date || param.schema.type == AllSchemaTypes.dateTime
                 self.isByteArray = param.schema.type == AllSchemaTypes.byteArray
             }
         } else if param.implementation == ImplementationLocation.client {
             self.value = "Client.\(param.serializedName ?? param.name)"
             self.optional = false
             self.paramName = nil
             self.type = param.schema.type
             self.isDate = false
             self.isByteArray = false
         } else if let constantSchema = param.schema as? ConstantSchema {
             self.type = constantSchema.valueType.type
             let value: String = constantSchema.value.value
             self.value = convertValueToStringInSwift(type: constantSchema.valueType.type, val: value)
             self.optional = false
             self.paramName = nil
             self.isDate = constantSchema.valueType.type == AllSchemaTypes.date || constantSchema.valueType
                 .type == AllSchemaTypes.dateTime
             self.isByteArray = constantSchema.valueType.type == AllSchemaTypes.byteArray
         */

        if let constantSchema = param.schema as? ConstantSchema {
            // let isString: Bool = constantSchema.valueType.type == AllSchemaTypes.string
            let val: String = constantSchema.value.value

            // self.value = isString ? "\"\(val)\"" : "\(val)"
            self.optional = false
            self.paramName = nil
            self.implementedInMethod = param.implementation == ImplementationLocation.method
            //   if param.implementation == ImplementationLocation.method {
            //       self.value = val

            //  } else {
            var value = convertValueToStringInSwift(type: constantSchema.valueType.type, val: val, key: key)
            self.value = (constantSchema.valueType.type == AllSchemaTypes.string) ? "\"\(value)\"" : "\(value)"
            //   }
            //   self.type = constantSchema.valueType.type
            //  self.isDate = false
            //  self.isByteArray = false
        } else if let signatureParameter = operation.signatureParameter(for: name) {
            // value is referring a signautre parameter, no need to wrap as String
            self.paramName = param.serializedName ?? param.name
            self.optional = !signatureParameter.required
            let swiftType = signatureParameter.schema.swiftType(optional: optional)

            var name = param.serializedName ?? param.name

            self.value = convertValueToStringInSwift(type: signatureParameter.schema.type, val: name, key: key)

            /*
             if swiftType.starts(with: "String") {
                 self.value = param.name
             } else if swiftType.starts(with: "Date") {
                 // self.value = "String(describing:\(param.name), format: Date.Format.iso8601)"
                 self.value = "\(key)String"
                 //    needDecoderBlock = true
                 keyValueType = KeyValueType.date
             } else if swiftType.starts(with: "["), !swiftType.contains("[String]") {
                 self.value = "\(key)String"
                 //    needDecoderBlock = true
                 keyValueType = KeyValueType.byeArray
             } else {
                 // Convert into String in generated code
                 self.value = "String(\(param.name))"
             }
             */
            self.implementedInMethod = false
            //    self.type = param.schema.type
            //    self.isDate = false
            //   self.isByteArray = false
        } else {
            /*  print(" param.name= \(param.name)")
             var abc = operation.signatureParameter(for: param.name)
             if abc == nil {
                 for ppp in operation.signatureParameters ?? [] {
                     print("ppp=\(ppp.name)")
                 }
                 print("aba is null")
             } else {
                 print("aba is not null")
             }*/

            self.value = ""
            self.optional = false
            self.paramName = nil
            self.implementedInMethod = false
            //   self.type = param.schema.type
            // self.needDecoderBlock = false`
            //      self.isDate = false
            //     self.isByteArray = false
        }

        //    self.needDecoderBlock = needDecoderBlock
        self.keyValueType = keyValueType.rawValue
        //   self.fromOption = false
        // self.type = param.schema.type
        // self.isDate = self.type == AllSchemaTypes.date || self.type == AllSchemaTypes.dateTime
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

        //  self.type = AllSchemaTypes.not
        self.keyValueType = KeyValueType.none.rawValue
        self.implementedInMethod = false
        //    self.isDate = false
        //   self.isByteArray = false
        //    self.fromOption = false
    }
}

func convertValueToStringInSwift(type: AllSchemaTypes, val: String, key: String? = nil) -> String {
    switch type {
    case AllSchemaTypes.string:
        return "\(val)"
    case AllSchemaTypes.integer,
         AllSchemaTypes.number:
        return "String(\(val))"
    case AllSchemaTypes.date,
         AllSchemaTypes.dateTime:
        return "\(key ?? val)String"
    //  return "String(\"\(val)\")"
    case AllSchemaTypes.choice,
         AllSchemaTypes.sealedChoice:
        return "\(val).rawValue"
    case AllSchemaTypes.boolean:
        return "String(\(val))"
    case AllSchemaTypes.array:
        return "\(val).map { String($0) }.joined(separator: \",\") "
    case AllSchemaTypes.byteArray:
        // return "String(bytes: \(val), encoding: .utf8)"
        return "\(key ?? val)String"
    default:
        return "\(val)333"
    }
}
