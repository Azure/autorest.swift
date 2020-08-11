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

enum ResponseBodyType: String {
    /// Service returns a pageable response
    case pagedBody
    /// Service returns some kind of deserializable object
    case body
    /// Service returns no response data, only a status code
    case noBody
}

/// View Model for method response handling.
struct ResponseViewModel {
    let statusCodes: [String]
    let objectType: String?
    /// Identifies the correct snippet to use when rendering the view model
    let strategy: ResponseBodyType

    init(from response: Response, with operation: Operation) {
        let httpResponse = response.protocol.http as? HttpResponse
        var statusCodes = [String]()
        httpResponse?.statusCodes.forEach { statusCodes.append($0.rawValue) }

        self.statusCodes = statusCodes

        // check if the request body schema type is object, store the object type of the response body
        let schemaResponse = response as? SchemaResponse
        self.objectType = schemaResponse?.schema.swiftType(optional: false)

        let hasSyncStateParameter = operation.parameter(for: "syncState") != nil
        self.strategy = objectType != nil ? ResponseBodyType
            .body : (hasSyncStateParameter ? ResponseBodyType.pagedBody : ResponseBodyType.noBody)
    }
}
