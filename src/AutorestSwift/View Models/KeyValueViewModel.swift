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
    // Flag indicates if value is optional
    let optional: Bool

    init(
        from parameter: Parameter? = nil,
        with codemodel: CodeModel? = nil,
        and operation: Operation? = nil,
        using key: String? = nil,
        modelValue: String? = nil
    ) {
        self.key = key ?? parameter?.serializedName! ?? ""

        if let param = parameter,
            let model = codemodel,
            let opt = operation {
            if let constantSchema = param.schema as? ConstantSchema {
                let isString: Bool = constantSchema.valueType.type == AllSchemaTypes.string
                let val: String = constantSchema.value.value

                self.value = isString ? "\"\(val)\"" : "\(val)"
                self.optional = false
            } else if let signatureParameter = opt.signatureParameters(for: param.name) {
                self.value = param.name
                self.optional = signatureParameter.required ?? true
            } else if let schema = model.schema(for: param.schema.name, withType: param.schema.type) {
                self.value = schema.name
                self.optional = false
            } else {
                self.value = ""
                self.optional = false
            }
        } else if let value = modelValue {
            self.value = value
            self.optional = false
        } else {
            self.value = ""
            self.optional = false
        }
    }
}
