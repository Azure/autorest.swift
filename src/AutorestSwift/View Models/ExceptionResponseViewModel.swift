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

/// View Model for method exception response handling.
struct ExceptionResponseViewModel {
    /// List of allowed response status codes
    let statusCodes: [String]

    /// Swift type annotation, including optionality, if applicable
    let type: String

    /// The comment to use for the return type
    let description: String?

    /// Indicates if the operation has a default exception
    let hasDefaultException: Bool

    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String

    init(from response: Response) {
        let httpResponse = response.protocol.http as? HttpResponse
        var statusCodes = [String]()
        httpResponse?.statusCodes.forEach { statusCodes.append($0.rawValue) }

        self.statusCodes = statusCodes.filter { $0 != "default" }.sorted()

        // check if the request body schema type is object, store the object type of the response body
        let schemaResponse = response as? SchemaResponse
        self.description = schemaResponse?.description

        if let type = schemaResponse?.schema.swiftType(),
            let schema = schemaResponse?.schema {
            self.strategy = ResponseBodyType.strategy(for: type, and: schema).rawValue
            self.type = type
        } else {
            self.strategy = ResponseBodyType.noBody.rawValue
            self.type = "Void"
        }

        if let errorResponseMetadata = response.extensions?["x-ms-error-response"]?.value as? Bool,
            errorResponseMetadata {
            guard type != "Void"
            else { fatalError("Did not find object type for error response") }
        }
        self.hasDefaultException = statusCodes.contains("default")
    }
}
