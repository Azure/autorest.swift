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
    let params: [ParameterViewModel]
    let returnType: ReturnTypeViewModel?
    // Query Params/Header can be placed inside QueryParameter Initializer
    let requiredQueryParams: [KeyValueViewModel]?
    let requiredHeaders: [KeyValueViewModel]?
    // Query Params/Header need to add Nil check
    let optionalQueryParams: [KeyValueViewModel]?
    let optionalHeaders: [KeyValueViewModel]?
    let uriParams: [KeyValueViewModel]?
    let requests: [RequestViewModel]?
    let responses: [ResponseViewModel]?
    let method: String?
    let path: String?

    init(from operation: Operation, with model: CodeModel) {
        self.name = operationName(for: operation.name)
        self.comment = ViewModelComment(from: operation.description)

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
        for param in operation.parameters ?? [] {
            guard let httpParam = param.protocol.http as? HttpParameter else { continue }

            switch httpParam.in {
            case .query:
                let viewModel = KeyValueViewModel(from: param, with: model, and: operation)
                viewModel.optional ? optionalQueryParams.append(viewModel) : requiredQueryParams.append(viewModel)
            case .header:
                let standardHeader = isStandardHttpHeader(with: param.serializedName!)

                let viewModel = KeyValueViewModel(
                    from: param,
                    with: model,
                    and: operation,
                    using: convertHttpHeaderKey(from: standardHeader?.rawValue ?? nil)
                )
                // Only standard http header and value can't be nil can be placed in header initializer
                standardHeader != nil && !viewModel.optional ? requiredHeaders.append(viewModel) : optionalHeaders
                    .append(viewModel)
            case .uri:
                uriParams.append(KeyValueViewModel(from: param, with: model, and: operation))
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

        if let headerValue = requests.first?.knownMediaType {
            requiredHeaders
                .append(KeyValueViewModel(key: ".contentType", value: headerValue))
        }

        if let headerValue = requests.first?.mediaTypes?.first {
            requiredHeaders
                .append(KeyValueViewModel(key: ".accept", value: headerValue))
        }

        self.returnType = ReturnTypeViewModel(from: responses.first?.objectType ?? "")

        self.params = items
        self.optionalQueryParams = optionalQueryParams
        self.optionalHeaders = optionalHeaders
        self.requiredQueryParams = requiredQueryParams
        self.requiredHeaders = requiredHeaders
        self.uriParams = uriParams
    }
}

private func isStandardHttpHeader(with headerName: String) -> HTTPHeaders? {
    for header in HTTPHeaders.allCases where header.rawValue == headerName {
        return header
    }
    return nil
}

private func convertHttpHeaderKey(from header: String?) -> String? {
    return header != nil ? "." + header!.replacingOccurrences(of: "-", with: "")
        .replacingOccurrences(of: "xms", with: "").lowercaseFirstLetter() : nil
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
