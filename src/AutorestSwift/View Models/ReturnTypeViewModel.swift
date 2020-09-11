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

/// View Model for method return type.
/// Example:
///     ... -> ReturnTypeName
struct ReturnTypeViewModel {
    let name: String
    let statusCodes: [String]
    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String
    let pagingNames: Language.PagingNames?

    init(from responses: [ResponseViewModel]?) {
        var statusCodes = Set<String>()
        var strategies = Set<ResponseBodyType>()
        for response in responses ?? [] {
            strategies.insert(response.strategy)
            for statusCode in response.statusCodes {
                statusCodes.insert(statusCode)
            }
        }

        assert(strategies.count <= 1, "Different strategy in ResponseViewModel is currently not supported.")
        self.statusCodes = Array(statusCodes)
        self.strategy = strategies.first?.rawValue ?? ResponseBodyType.noBody.rawValue

        let response = responses?.first
        self.pagingNames = response?.pagingNames
        if let elementType = response?.pagedElementClassName, response?.pagingNames != nil {
            self.name = "PagedCollection<\(elementType)>"
        } else {
            self.name = response?.objectType ?? "Void"
        }
    }
}
