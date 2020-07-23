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

struct EnumerationChoiceViewModel {
    let name: String
    let comment: String?
    let value: String

    init(from schema: ChoiceValue) {
        self.name = schema.name
        self.comment = schema.description
        self.value = schema.value
    }
}

struct EnumerationViewModel {
    let name: String
    let comment: String?
    let type: String
    let choices: [EnumerationChoiceViewModel]

    init(from schema: ChoiceSchema) {
        self.name = schema.name
        self.comment = schema.description
        self.type = schema.choiceType.name

        var items = [EnumerationChoiceViewModel]()
        for choice in schema.choices {
            items.append(EnumerationChoiceViewModel(from: choice))
        }
        self.choices = items
    }

    init(from schema: SealedChoiceSchema) {
        self.name = schema.name
        self.comment = schema.description
        self.type = schema.choiceType.name

        var items = [EnumerationChoiceViewModel]()
        for choice in schema.choices {
            items.append(EnumerationChoiceViewModel(from: choice))
        }
        self.choices = items
    }
}

struct EnumerationFileViewModel {
    let enums: [EnumerationViewModel]

    init(from schema: Schemas) {
        var items = [EnumerationViewModel]()
        for choice in schema.choices ?? [] {
            items.append(EnumerationViewModel(from: choice))
        }
        for choice in schema.sealedChoices ?? [] {
            items.append(EnumerationViewModel(from: choice))
        }
        self.enums = items
    }
}
