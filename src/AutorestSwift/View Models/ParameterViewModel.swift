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

/// View Model for a method signature parameter.
/// Example:
///     name: String? = nil
struct ParameterViewModel {
    /// Name of the parameter
    let name: String

    /// The value or variable path to the value of the parameter
    let pathOrValue: String

    /// Swift type annotation, including optionality, if applicable
    let type: String

    /// Swift type annotation, disregarding optionality
    let typeName: String

    /// Whether the parameter is required or not
    let optional: Bool

    /// Default value for the parameter
    let defaultValue: ViewModelDefault

    /// Comment value for the parameter
    let comment: ViewModelComment

    /// Where the parameter goes in terms of the request
    let location: String

    /// Whether to URL encode the parameter or not
    let encode: String

    init(from param: ParameterType, with operation: Operation? = nil, withName specificName: String? = nil) {
        if let name = specificName, !name.isEmpty {
            self.name = name
        } else {
            self.name = param.variableName
        }
        self.optional = !param.required
        self.type = param.schema.swiftType(optional: optional)
        self.typeName = param.schema.swiftType(optional: false)
        self.defaultValue = ViewModelDefault(from: param.clientDefaultValue, isString: true, isOptional: optional)
        self.comment = ViewModelComment(from: param.description)
        self.encode = param.value.isSkipUrlEncoding ? "skipEncoding" : "encode"
        self.location = param.paramLocation?.rawValue ?? "???"
        if let op = operation {
            self.pathOrValue = "TODO"
        } else {
            self.pathOrValue = "???"
        }
    }
}
