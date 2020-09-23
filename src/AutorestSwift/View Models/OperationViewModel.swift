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
    var body: BodyParams?
    var signature: [ParameterViewModel]
    var method: [GlobalParameterViewModel]
    var hasOptionalParams: Bool

    /// Build a list of required and optional query params and headers from a list of parameters
    init(parameters: [ParameterType], operation: Operation) {
        var header = Params()
        var query = Params()
        var path = [KeyValueViewModel]()
        var method = [GlobalParameterViewModel]()

        for param in parameters {
            guard let httpParam = param.protocol.http as? HttpParameter else { continue }

            if param.implementation == ImplementationLocation.method {
                if let methodViewModel = try? GlobalParameterViewModel(from: param) {
                    method.append(methodViewModel)
                }
            }
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

        // Add a blank key,value in order for Stencil generates an empty dictionary for QueryParams and PathParams constructor
        if query.required.isEmpty {
            query.required.append(KeyValueViewModel(key: "", value: "\"\""))
        }
        if path.isEmpty {
            path.append(KeyValueViewModel(key: "", value: "\"\""))
        }

        // If there is no optional query params, change query param declaration to 'let'
        // For header, the declaration is 'let' when both required and optional headers are empty, since the required
        // header parameters will be initialized out of header initializer
        query.declaration = query.optional.isEmpty ? "let" : "var"
        header.declaration = header.isEmpty ? "let" : "var"

        // Set the body param, if applicable
        if let bodyParam = operation.request?.bodyParam {
            let bodyParamName = operation.request?.bodyParamName(for: operation)
            let virtualParams = parameters.virtual

            self.body = BodyParams(
                param: ParameterViewModel(from: bodyParam, withName: bodyParamName),
                strategy: bodyParam.flattened ? .flattened : .plain,
                children: virtualParams.map { VirtualParam(from: $0) }
            )
        } else {
            self.body = nil
        }

        var signatureParameterViewModel = [ParameterViewModel]()
        for param in parameters.inSignature {
            signatureParameterViewModel.append(ParameterViewModel(from: param))
        }
        self.signature = signatureParameterViewModel

        self.method = method
        self.header = header
        self.query = query
        self.path = path
        self.hasOptionalParams = !(query.optional.isEmpty && header.optional.isEmpty)
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

    var isEmpty: Bool {
        return required.isEmpty && optional.isEmpty
    }
}

enum BodyParamStrategy: String {
    case plain
    case flattened
}

struct BodyParams {
    var param: ParameterViewModel
    var strategy: String
    var children: [VirtualParam]

    init(param: ParameterViewModel, strategy: BodyParamStrategy, children: [VirtualParam]) {
        self.param = param
        self.strategy = strategy.rawValue
        self.children = children
        // Suppress comma on final child
        if !children.isEmpty {
            self.children[children.count - 1].separator = ""
        }
    }
}

struct VirtualParam {
    var name: String
    var path: String
    var separator: String

    init(from param: VirtualParameter) {
        self.name = param.name
        self.path = param.required ? param.name : "options?.\(param.name)"
        self.separator = ","
    }
}

/// View Model for an operation.
/// Example:
///     // a simple endpoint
///     public func simpleEndpoint(param: String? = nil, completionHandler: @escaping HTTPResultHandler<ReturnType>) { ... }
struct OperationViewModel {
    /// Name of the operation
    let name: String

    /// Comment association with the operation
    let comment: ViewModelComment

    let signatureComment: ViewModelComment

    let params: OperationParameters

    let returnType: ReturnTypeViewModel

    let clientMethodOptions: ClientMethodOptionsViewModel

    let pipelineContext: [KeyValueViewModel]

    let request: RequestViewModel
    let responses: [ResponseViewModel]
    let exceptions: [ExceptionResponseViewModel]

    let defaultException: ExceptionResponseViewModel?
    let defaultExceptionHasBody: Bool
    let needHttpResponseData: Bool

    init(from operation: Operation, with model: CodeModel, key: String) {
        guard let request = operation.request else { fatalError("Request not found for operation \(operation.name).") }
        self.request = RequestViewModel(from: request, with: operation)

        self.name = operationName(for: operation)
        self.comment = ViewModelComment(from: operation.description)

        let params = operation.allParams

        var responses = [ResponseViewModel]()
        for response in operation.responses ?? [] {
            responses.append(ResponseViewModel(from: response, with: operation))
        }

        var exceptions = [ExceptionResponseViewModel]()
        var defaultException: ExceptionResponseViewModel?
        for exception in operation.exceptions ?? [] {
            let viewModel = ExceptionResponseViewModel(from: exception)
            if viewModel.hasDefaultException {
                defaultException = viewModel
            } else {
                exceptions.append(viewModel)
            }
        }

        // Build up allowable status codes that can be returned from the service.
        var statusCodes = [String]()
        for response in responses {
            statusCodes += response.statusCodes
        }
        for exception in exceptions {
            statusCodes += exception.statusCodes
        }

        // Configure PipelineContext
        var pipelineContext = [KeyValueViewModel]()
        pipelineContext.append(KeyValueViewModel(
            key: "ContextKey.allowedStatusCodes.rawValue",
            value: "[\(statusCodes.joined(separator: ","))]"
        ))
        self.pipelineContext = pipelineContext

        self.responses = responses
        self.exceptions = exceptions
        self.defaultException = defaultException
        let defaultExceptionHasBody = (defaultException != nil) && defaultException?.objectType != "Void"

        let returnType = ReturnTypeViewModel(from: self.responses)

        // create help struct to manage required and optional params in
        // headers/query/path, etc.
        self.params = OperationParameters(parameters: params, operation: operation)

        var signatureComments: [String] = []
        if let param = self.params.body?.param {
            signatureComments.append("   - \(param.name) : \(param.comment.withoutPrefix)")
        }
        for param in params.inSignature where param.description != "" {
            signatureComments.append("   - \(param.name) : \(param.description)")
        }
        self.signatureComment = ViewModelComment(from: signatureComments.joined(separator: "\n"))

        self.clientMethodOptions = ClientMethodOptionsViewModel(
            from: operation,
            with: model,
            parameters: params.inOptions,
            key: key
        )

        self.returnType = returnType
        self.defaultExceptionHasBody = defaultExceptionHasBody
        self.needHttpResponseData = exceptions.count > 1 || (returnType.name != "Void") || defaultExceptionHasBody
    }
}

private func filterParams(for params: [ParameterType]?, with allowed: [ParameterLocation]) -> [ParameterType] {
    let optionsParams = params?.filter { param in
        if let httpParam = param.protocol.http as? HttpParameter {
            return allowed.contains(httpParam.in)
        } else {
            return false
        }
    }
    return optionsParams ?? []
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

    // Strip off the body param name, if there is one and the parameter is not flattened.
    // (ex: `createCat(...)` becomes `create(cat:...)`
    if let bodyParamName = operation.request?.bodyParamName(for: operation) {
        let suffix = bodyParamName.prefix(1).uppercased() + bodyParamName.dropFirst()
        if operationName.hasSuffix(suffix), !(operation.request?.bodyParam?.flattened ?? false) {
            operationName = String(operationName.dropLast(suffix.count))
        }
    }
    return operationName
}
