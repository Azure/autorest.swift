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
    let key: String
    let value: String
    let valueNilable: Bool

    init(from param: Parameter, with model: CodeModel, and operation: Operation, using key: String? = nil) {
        self.key = key ?? param.serializedName!

        if let constantSchema = param.schema as? ConstantSchema {
            let isString: Bool = constantSchema.valueType.type == AllSchemaTypes.string
            let val: String = constantSchema.value.value

            self.value = isString ? "\"\(val)\"" : "\(val)"
            self.valueNilable = false
        } else if let signatureParameter = operation.signatureParameters(for: param.name) {
            self.value = param.name
            self.valueNilable = signatureParameter.required ?? true
        } else if let schema = model.schema(for: param.schema.name, withType: param.schema.type) {
            self.value = schema.name
            self.valueNilable = false
        } else {
            self.value = ""
            self.valueNilable = false
        }
    }

    init(key: String, value: String) {
        self.key = key
        self.value = value
        self.valueNilable = false
    }
}
