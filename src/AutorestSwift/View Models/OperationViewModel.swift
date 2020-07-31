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

/// View Model for an operation.
/// Example:
///     // a simple endpoint
///     public func simpleEndpoint(param: String? = nil, completionHandler: @escaping HTTPResultHandler<ReturnType>) { ... }
struct OperationViewModel {
    let name: String
    let comment: ViewModelComment
    let signatureComment: ViewModelComment
    let params: [ParameterViewModel]
    let returnType: ReturnTypeViewModel?
    // Query Params/Header can be placed inside QueryParameter Initializer
    let requiredQueryParams: [KeyValueViewModel]?
    let requiredHeaders: [KeyValueViewModel]?
    // Query Params/Header need to add Nil check
    let optionalQueryParams: [KeyValueViewModel]?
    let optionalHeaders: [KeyValueViewModel]?
    let pipelineContext: [KeyValueViewModel]?
    let uriParams: [KeyValueViewModel]?
    let requests: [RequestViewModel]?
    let responses: [ResponseViewModel]?
    let method: String?
    let path: String?

    init(from operation: Operation) {
        self.name = operationName(for: operation.name)
        self.comment = ViewModelComment(from: operation.description)

        var allSignagureComments: [String] = []
        for param in operation.signatureParameters ?? [] where param.description != "" {
            allSignagureComments.append("   - \(param.name) : \(param.description)")
        }
        self.signatureComment = ViewModelComment(from: allSignagureComments.joined(separator: "\n"))

        // operation parameters should be all the signature paramters from the schema
        // and the signature parameters of the Request
        var items = [ParameterViewModel]()
        for param in operation.signatureParameters ?? [] {
            items.append(ParameterViewModel(from: param))
        }

        var requiredQueryParams = [KeyValueViewModel]()
        var requiredHeaders = [KeyValueViewModel]()
        var optionalQueryParams = [KeyValueViewModel]()
        var optionalHeaders = [KeyValueViewModel]()
        var uriParams = [KeyValueViewModel]()
        var pipelineContext = [KeyValueViewModel]()

        for param in operation.parameters ?? [] {
            guard let httpParam = param.protocol.http as? HttpParameter else { continue }

            let viewModel = KeyValueViewModel(from: param, with: operation)

            switch httpParam.in {
            case .query:
                viewModel.optional ? optionalQueryParams.append(viewModel) : requiredQueryParams.append(viewModel)
            case .header:
                viewModel.optional ? optionalHeaders.append(viewModel) : requiredHeaders
                    .append(viewModel)
            case .uri:
                uriParams.append(viewModel)
            default:
                continue
            }
        }

        var requests = [RequestViewModel]()
        var responses = [ResponseViewModel]()

        for request in operation.requests ?? [] {
            requests.append(RequestViewModel(from: request))
        }

        for response in operation.responses ?? [] {
            responses.append(ResponseViewModel(from: response))
        }

        self.requests = requests
        self.responses = responses

        // TODO: only support max 1 request and  max 1 response for now
        for param in requests.first?.params ?? [] {
            items.append(param)
        }

        self.method = requests.first?.method
        self.path = requests.first?.path

        if let headerValue = requests.first?.knownMediaType,
            headerValue != "" {
            requiredHeaders
                .append(KeyValueViewModel(key: "Content-Type", value: "\"\(headerValue)\""))
        }

        if let headerValue = responses.first?.mediaTypes?.first,
            headerValue != "" {
            requiredHeaders
                .append(KeyValueViewModel(key: "Accept", value: "\"\(headerValue)\""))
        }

        if let statusCodes = responses.first?.statusCodes {
            pipelineContext
                .append(KeyValueViewModel(
                    key: "ContextKey.allowedStatusCodes.rawValue",
                    value: "[\(statusCodes.joined(separator: ","))]"
                ))
        }

        self.returnType = ReturnTypeViewModel(from: responses.first, with: operation)

        self.params = items
        self.optionalQueryParams = optionalQueryParams
        self.optionalHeaders = optionalHeaders

        // Add a blank key,value in order for Stencil generates an empty dictionary for QueryParams constructor
        if requiredQueryParams.count == 0 { requiredQueryParams.append(KeyValueViewModel(key: "", value: "")) }

        self.pipelineContext = pipelineContext
        self.requiredQueryParams = requiredQueryParams
        self.requiredHeaders = requiredHeaders
        self.uriParams = uriParams
    }
}

private func operationName(for operationName: String) -> String {
    let pluralReplacements = [
        "get": "list"
    ]

    var nameComps = operationName.splitAndJoinAcronyms

    // TODO: Need a more reliable way to know whether the last item is singular or plural
    let isPlural = nameComps.last?.hasSuffix("s") ?? false
    for (index, comp) in nameComps.enumerated() {
        if index == 0 {
            if isPlural, let replacement = pluralReplacements[comp] {
                nameComps[index] = replacement
            }
        } else {
            nameComps[index] = comp.capitalized
        }
    }
    return nameComps.joined()
}
