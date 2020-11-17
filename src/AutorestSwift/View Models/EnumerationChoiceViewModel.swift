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

/// View Model for an enumeration choice.
/// Example:
///     // a simple choice
///     case simple = "Simple"
struct EnumerationChoiceViewModel {
    let name: String
    let comment: ViewModelComment
    let value: String

    init(from schema: ChoiceValue) {
        // Model4 passed in ChoiceValue name with first letter in Upper case despite the setting
        // for ChoiceValue is set to `camelcase` in README.md
        // Enum value starts with an Upper case will cause swiftlint error and swiftlint autocorrect will not fix this issue.
        // As a workaround, we lower caes the first letter of ChoiceValue in the view model.
        self.name = schema.variableName
        self.comment = ViewModelComment(from: schema.description)
        self.value = schema.value
    }
}
