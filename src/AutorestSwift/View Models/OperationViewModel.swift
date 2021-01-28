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

// swiftlint:disable cyclomatic_complexity

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

    let pipelineContext: PipelineContextViewModel

    let request: RequestViewModel
    let responses: [ResponseViewModel]
    let exceptions: [ExceptionResponseViewModel]

    let defaultException: ExceptionResponseViewModel?
    let defaultExceptionHasBody: Bool
    let needHttpResponseData: Bool
    let validation: [String: Validation]
    let hasValidation: Bool

    init(from operation: Operation, with model: CodeModel, groupName: String) {
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
        self.pipelineContext = PipelineContextViewModel(allowedStatusCodes: statusCodes)

        self.responses = responses
        self.exceptions = exceptions
        self.defaultException = defaultException
        let defaultExceptionHasBody = (defaultException != nil) && defaultException?.type != "Void"

        let returnType = ReturnTypeViewModel(from: self.responses)

        // create help struct to manage required and optional params in
        // headers/query/path, etc.
        self.params = OperationParameters(parameters: params, operation: operation, model: model)

        var signatureComments: [String] = []
        if let bodyParam = self.params.body {
            if !bodyParam.flattened,
                bodyParam.strategy != BodyParamStrategy.constant.rawValue {
                signatureComments.append("   - \(bodyParam.param.name) : \(bodyParam.param.comment.withoutPrefix)")
            }
        }
        for param in params.inSignature(model: model) where param.description != "" {
            signatureComments.append("   - \(param.name) : \(param.description)")
        }
        self.signatureComment = ViewModelComment(from: signatureComments.joined(separator: "\n"))

        self.clientMethodOptions = ClientMethodOptionsViewModel(
            from: operation,
            with: model,
            parameters: params.inOptions,
            groupName: groupName
        )

        self.returnType = returnType
        self.defaultExceptionHasBody = defaultExceptionHasBody
        self.needHttpResponseData = exceptions.count > 1 || (returnType.type != "Void") || defaultExceptionHasBody
        var validations = [String: Validation]()
        for param in params {
            // determine the appropriate prefix
            var prefix = param.located(in: .body) ? self.params.body!.param.name : param.variableName
            if !param.required {
                prefix = "\(prefix)?"
            }
            if let objectSchema = param.schema as? ObjectSchema {
                if let objectValidation = Validation.from(objectSchema: objectSchema, withPrefix: prefix) {
                    validations.merge(objectValidation) { current, _ in current }
                }
            } else {
                if let validation = Validation(with: param.schema, path: param.variableName) {
                    validations[param.variableName] = validation
                }
            }
        }
        self.validation = validations
        self.hasValidation = !validations.isEmpty
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
    var nameComps = swaggerName.splitAndJoinAcronyms

    // use `list` name if `x-ms-pageable` is set
    if operation.extensions?["x-ms-pageable"]?.value as? [String: String] != nil {
        nameComps[0] = "list"
    }

    for (index, comp) in nameComps.enumerated() {
        nameComps[index] = index == 0 ? comp.lowercased() : comp.capitalized
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
