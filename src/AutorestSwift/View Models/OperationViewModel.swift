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

struct OperationParameters {
    var header: Params
    var query: Params
    var path: [KeyValueViewModel]

    /// Build a list of required and optional query params and headers from a list of parameters
    init(
        parameters: [Parameter]?,
        operation: Operation,
        operationParameters: OperationParameters? = nil
    ) {
        self.header = operationParameters?.header ?? Params()
        self.query = operationParameters?.query ?? Params()
        self.path = operationParameters?.path ?? [KeyValueViewModel]()

        for param in parameters ?? [] {
            guard let httpParam = param.protocol.http as? HttpParameter else { continue }

            let viewModel = KeyValueViewModel(from: param, with: operation)

            switch httpParam.in {
            case .query:
                viewModel.optional ? query.optional.append(viewModel) : query.required
                    .append(viewModel)
            case .header:
                viewModel.optional ? header.optional.append(viewModel) : header.required
                    .append(viewModel)
            case .path:
                path.append(viewModel)
            default:
                continue
            }
        }
    }
}

struct Params {
    // Query Params/Header in initializer
    var required: [KeyValueViewModel]
    // Query Params/Header need to add Nil check
    var optional: [KeyValueViewModel]

    init(from params: Params? = nil) {
        self.required = params?.required ?? [KeyValueViewModel]()
        self.optional = params?.optional ?? [KeyValueViewModel]()
    }
}

/// View Model for an operation.
/// Example:
///     // a simple endpoint
///     public func simpleEndpoint(param: String? = nil, completionHandler: @escaping HTTPResultHandler<ReturnType>) { ... }
struct OperationViewModel {
    let name: String
    let comment: ViewModelComment
    let signatureComment: ViewModelComment
    let signatureParams: [ParameterViewModel]
    let returnType: ReturnTypeViewModel?
    let params: OperationParameters
    let pipelineContext: [KeyValueViewModel]?
    private let requests: [RequestViewModel]?
    private let responses: [ResponseViewModel]?
    let request: RequestViewModel?
    let clientMethodOptions: ClientMethodOptionsViewModel

    init(from operation: Operation, with model: CodeModel) {
        self.name = operationName(for: operation.name)
        self.comment = ViewModelComment(from: operation.description)

        var pipelineContext = [KeyValueViewModel]()

        var params = OperationParameters(
            parameters: operation.parameters,
            operation: operation
        )

        var signatureParams = filterParams(for: operation.signatureParameters, with: [.path, .uri, .body])
        var optionsParams = filterParams(for: operation.signatureParameters, with: [.header, .query])

        var requests = [RequestViewModel]()
        var responses = [ResponseViewModel]()

        for request in operation.requests ?? [] {
            requests.append(RequestViewModel(from: request))

            let requestSignatureParams = filterParams(for: request.signatureParameters, with: [.path, .uri, .body])
            let requestOptionsParams = filterParams(
                for: request.signatureParameters,
                with: [.header, .query]
            )

            optionsParams.append(contentsOf: requestOptionsParams)
            signatureParams.append(contentsOf: requestSignatureParams)

            params = OperationParameters(
                parameters: request.parameters,
                operation: operation,
                operationParameters: params
            )
        }

        for response in operation.responses ?? [] {
            responses.append(ResponseViewModel(from: response, with: operation))
        }

        var statusCodes = [String]()
        responses.forEach {
            statusCodes.append(contentsOf: $0.statusCodes)
        }

        pipelineContext.append(KeyValueViewModel(
            key: "ContextKey.allowedStatusCodes.rawValue",
            value: "[\(statusCodes.joined(separator: ","))]"
        ))

        self.requests = requests
        self.responses = responses

        // current logic only supports a single request and response
        assert(requests.count <= 1, "Multiple requests per operation is currently not supported... \(operation.name)")
        assert(
            responses.filter { $0.strategy != ResponseBodyType.noBody }.count <= 1,
            "Multiple Nobody responses per operation is currently not supported... \(operation.name)"
        )
        self.request = requests.first
        let response = responses.first

        // TODO: Remove this special logic to get Accept header value when the value is available in yaml file
        if let headerValue = response?.mediaTypes?.first,
            headerValue != "" {
            params.header.required
                .append(KeyValueViewModel(key: "Accept", value: "\"\(headerValue)\""))
        }

        self.returnType = ReturnTypeViewModel(from: response)

        var signaturePropertyViewModel = [ParameterViewModel]()
        signatureParams.forEach {
            signaturePropertyViewModel.append(ParameterViewModel(from: $0))
        }

        var signatureComments: [String] = []
        for param in signatureParams where param.description != "" {
            signatureComments.append("   - \(param.name) : \(param.description)")
        }
        self.signatureComment = ViewModelComment(from: signatureComments.joined(separator: "\n"))

        self.signatureParams = signaturePropertyViewModel

        // Add a blank key,value in order for Stencil generates an empty dictionary for QueryParams and PathParams constructor
        if params.query.required.count == 0 { params.query.required.append(KeyValueViewModel(key: "", value: "")) }
        if params.path.count == 0 { params.path.append(KeyValueViewModel(key: "", value: "\"\"")) }

        self.params = params
        self.pipelineContext = pipelineContext

        self.clientMethodOptions = ClientMethodOptionsViewModel(
            from: operation,
            with: model,
            parameters: optionsParams
        )

        // validate our assumption that there won't be any "required options"
        for param in optionsParams {
            assert(param.required == false, "Unexpectedly found a required 'option'... \(param.name)")
        }
    }
}

private func filterParams(for params: [Parameter]?, with allowed: [ParameterLocation]) -> [Parameter] {
    let optionsParams = params?.filter { param in
        if let httpParam = param.protocol.http as? HttpParameter {
            return allowed.contains(httpParam.in)
        } else {
            return false
        }
    }
    return optionsParams ?? []
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
