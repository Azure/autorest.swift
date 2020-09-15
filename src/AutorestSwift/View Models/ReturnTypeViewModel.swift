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
    // A flag to indicate in the generated code whether to return nil or void in the NoBody response stencil
    // If the Return type of the function is nilable, we need to return nil. If the return type is Void, we return ()
    let returnNil: Bool

    init(from responses: [ResponseViewModel]?) {
        var objectTypes = Set<String>()
        var strategies = Set<String>()
        for response in responses ?? [] {
            if response.strategy != "noBody" {
                objectTypes.insert(response.objectType)
            }
            strategies.insert(response.strategy)
        }

        // Only supprt at most 1 body or pageBody return type now.
        let withBodyStrategies = strategies.filter { $0 != "noBody" }
        let hasNoBodyStratgies = strategies.contains { $0 == "noBody" }
        assert(withBodyStrategies.count <= 1)

        // since we only support 1 body/pagePage response, only need to take the first item fro objectTypes
        if let name = objectTypes.first {
            self.name = hasNoBodyStratgies ? "\(name)?" : name
            self.returnNil = hasNoBodyStratgies
        } else {
            self.name = "Void"
            self.returnNil = false
        }
    }
}
