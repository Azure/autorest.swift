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

/// View Model for an operation group
/// Example:
///     // MARK: OperationGroupName
///     ...
struct OperationGroupViewModel {
    let name: String
    let visibility: String
    let operations: [OperationViewModel]
    let comment: ViewModelComment

    init(from group: OperationGroup, with model: CodeModel) {
        let name = group.name.isEmpty ? model.name : group.modelName

        var groupName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        // if the operation group name has a collision with a model object, append 'Operation' to the operation group name
        // or group name is a reserved keyword
        if model.object(for: groupName) != nil {
            groupName += "Operation"
        }

        // Operation group visibility should match that of the client
        let clientName = Manager.shared.args!.generateAsInternal.aliasOrName(for: "\(model.packageName)Client")
        self.visibility = Manager.shared.args!.generateAsInternal.visibility(for: clientName)

        self.name = groupName
        self.comment = ViewModelComment(from: group.description)
        var items = [OperationViewModel]()
        for operation in group.operations {
            items.append(OperationViewModel(from: operation, with: model, groupName: groupName))
        }
        self.operations = items
    }
}
