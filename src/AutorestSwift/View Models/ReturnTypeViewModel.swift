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

enum BodyType: String {
    /// Service returns a pageable response
    case pagedBody
    /// Service returns some kind of deserializable object
    case body
    /// Service returns no response data, only a status code
    case noBody
}

/// View Model for method return type.
/// Example:
///     ... -> ReturnTypeName
struct ReturnTypeViewModel {
    let name: String
    let strategy: String

    init(from response: ResponseViewModel?, with operation: Operation) {
        self.name = response?.objectType ?? "Void"
        let hasSyncStateParameter = operation.parameter(for: "syncState") != nil

        self.strategy = response?.objectType != nil ? BodyType.body
            .rawValue : (hasSyncStateParameter ? BodyType.pagedBody.rawValue : BodyType.noBody.rawValue)
    }
}
