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

enum RequestBodyType: String {
    /// Service requires some kind of serialized object
    case body
    /// Service requires no request body
    case noBody
    /// Service requires a serialzed JSON merge-patch body
    case patchBody
}

struct BodyParamViewModel {
    let name: String
    let type: String
    let flattened: Bool
    let properties: [ParameterViewModel]

    init(from parameter: ParameterType, with operation: Operation) {
        self.name = operation.request?.bodyParamName(for: operation) ?? parameter.name
        self.type = parameter.schema.name
        self.flattened = parameter.flattened
        var properties = [ParameterViewModel]()
        // FIXME: Create metadata for the virtual properties
        self.properties = properties
    }
}

/// View Model for the method request creation.
struct RequestViewModel {
    let path: String
    let method: String
    let bodyParam: BodyParamViewModel?
    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String

    init(from request: Request, with operation: Operation) {
        // load HttpRequest properties
        let httpRequest = request.protocol.http as? HttpRequest
        self.path = httpRequest?.path ?? ""
        self.method = httpRequest?.method.rawValue ?? ""

        // create a body param model, if the request has one
        if let bodyParam = request.bodyParam {
            self.bodyParam = BodyParamViewModel(from: bodyParam, with: operation)
        } else {
            self.bodyParam = nil
        }

        // Determine which kind of request body snippet to render
        if method == "patch" {
            if let contentTypeParameter = request.parameter(for: "Content-Type"),
                let constantSchema = contentTypeParameter.schema as? ConstantSchema,
                constantSchema.value.value == "application/json" {
                self.strategy = RequestBodyType.body.rawValue
            } else {
                self.strategy = RequestBodyType.patchBody.rawValue
            }
        } else {
            self.strategy = bodyParam != nil ? RequestBodyType.body.rawValue : RequestBodyType.noBody.rawValue
        }
    }
}
