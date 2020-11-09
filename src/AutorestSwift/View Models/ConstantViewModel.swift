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

/// View Model for a constant model property.
/// Example:
///     // a constant property
///     let constant = "default"
struct ConstantViewModel {
    let name: String
    let comment: ViewModelComment
    // default value of the proeprty
    let defaultValue: ViewModelDefault
    let required: Bool

    /// Initialize from Value type (such as Property or Parameter)
    init(from schema: ConstantSchema, required: Bool) {
        let name = (schema.serializedName ?? schema.name).lowercasedFirst
        assert(!name.isEmpty)
        self.name = name
        self.comment = ViewModelComment(from: schema.description)
        self.defaultValue = ViewModelDefault(from: schema.value.value, isString: true, isOptional: false)
        self.required = required
    }
}
