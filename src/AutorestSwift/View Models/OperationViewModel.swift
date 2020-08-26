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
    var body: Params
    var path: [KeyValueViewModel]
    var hasOptionalsParams: Bool = false

    init(for operation: Operation) {
        self.header = Params()
        self.query = Params()
        self.body = Params()
        self.path = [KeyValueViewModel]()

        for param in operation.parameters ?? [] {
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
            case .body:
                fatalError("Body parameter not expected in operation parameters.")
            default:
                continue
            }
        }
    }

    mutating func update(with request: Request, for operation: Operation) {
        for param in request.signatureParameters ?? [] {
            guard let httpParam = param.protocol.http as? HttpParameter else { continue }
            let viewModel = KeyValueViewModel(from: param, with: operation)
            switch httpParam.in {
            case .query:
                viewModel.optional ? query.optional.append(viewModel) : query.required.append(viewModel)
            case .header:
                viewModel.optional ? header.optional.append(viewModel) : header.required.append(viewModel)
            case .path:
                path.append(viewModel)
            case .body:
                viewModel.optional ? body.optional.append(viewModel) : body.required.append(viewModel)
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
    // Whether to 'var' or 'let' in generated code for the param declaration
    var declaration: String = "var"

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
    let returnType: ReturnTypeViewModel?
    let params: OperationParameters
    let pipelineContext: [KeyValueViewModel]?
    let request: RequestViewModel?

    //    let clientMethodOptions: ClientMethodOptionsViewModel
    //    let bodyParam: ParameterViewModel?
    //    let signatureParams: [ParameterViewModel]

    private let requests: [RequestViewModel]?
    private let responses: [ResponseViewModel]?

    init(from operation: Operation, with model: CodeModel) {
        guard let request = operation.request else { fatalError("No request found for operation \(operation.name).") }

        self.name = operationName(for: operation)
        self.comment = ViewModelComment(from: operation.description)

        var params = OperationParameters(for: operation)
        params.update(with: request, for: operation)

        if name == "sendMessage" {
            let test = "best"
        }

        self.request = RequestViewModel(from: request, with: operation)

        // Build up response view model
        var responses = [ResponseViewModel]()
        for response in operation.responses ?? [] {
            responses.append(ResponseViewModel(from: response, with: operation))
        }
        var statusCodes = [String]()
        responses.forEach {
            statusCodes.append(contentsOf: $0.statusCodes)
        }
        var pipelineContext = [KeyValueViewModel]()
        pipelineContext.append(KeyValueViewModel(
            key: "ContextKey.allowedStatusCodes.rawValue",
            value: "[\(statusCodes.joined(separator: ","))]"
        ))
        self.pipelineContext = pipelineContext

        // current logic only supports a single '.noBody' response
        self.responses = responses
        assert(
            responses.filter { $0.strategy != ResponseBodyType.noBody }.count <= 1,
            "Multiple '.noBody' responses per operation is currently not supported... \(operation.name)"
        )
        let response = responses.first

        // FIXME: Refine this?
        var signaturePropertyViewModel = [ParameterViewModel]()
        for param in signatureParams {
            signaturePropertyViewModel.append(ParameterViewModel(from: param))
        }
        self.signatureParams = signaturePropertyViewModel

        self.returnType = ReturnTypeViewModel(from: response)
        self.signatureComment = buildSignatureComment(from: params)


        // Add a blank key,value in order for Stencil generates an empty dictionary for QueryParams and PathParams constructor
        if params.query.required.count == 0 { params.query.required.append(KeyValueViewModel(key: "", value: "")) }
        if params.path.count == 0 { params.path.append(KeyValueViewModel(key: "", value: "\"\"")) }

        // If there is no optional query params, change query param declaration to 'let'
        // For header, the declaration is 'let' when both required and optional headers are empty, since the required
        // header parameters will be initialized out of header initializer
        params.query.declaration = params.query.optional.count == 0 ? "let" : "var"
        params.header.declaration = params.header.optional.count == 0 && params.header.required
            .count == 0 ? "let" : "var"
        params.hasOptionalsParams = params.query.optional.count + params.header.optional.count > 0

        self.params = params

        self.clientMethodOptions = ClientMethodOptionsViewModel(
            from: operation,
            with: model,
            parameters: optionsParams
        )
    }
}

private func buildSignatureComment(from params: OperationParameters) -> ViewModelComment {
    var signatureComments: [String] = []
    if let param = bodyParam, param.flattened == false {
        signatureComments.append("   - \(param.name) : \(param.comment.withoutPrefix)")
    }
    for param in signatureParams where param.description != "" {
        signatureComments.append("   - \(param.name) : \(param.description)")
    }
    return ViewModelComment(from: signatureComments.joined(separator: "\n"))
}

private func operationName(for operation: Operation) -> String {
    let swaggerName = operation.name
    var operationName = swaggerName
    let pluralReplacements = [
        "get": "list"
    ]
    var nameComps = swaggerName.splitAndJoinAcronyms

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
    operationName = nameComps.joined()

    // Strip off the body param name, if there is one.
    // (ex: `createCat(...)` becomes `create(cat:...)`
    if let bodyParamName = operation.request?.bodyParamName(for: operation) {
        let suffix = bodyParamName.prefix(1).uppercased() + bodyParamName.dropFirst()
        if operationName.hasSuffix(suffix) {
            operationName = String(operationName.dropLast(suffix.count))
        }
    }
    return operationName
}
