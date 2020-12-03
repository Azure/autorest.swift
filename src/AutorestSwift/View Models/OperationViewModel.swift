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
struct OperationParameters {
    let all: [ParameterViewModel]
    let signature: [ParameterViewModel]
    var body: BodyParams?

    /// Initialize with a list of `ParameterType`.
    init(parameters: [ParameterType], operation: Operation) {
        var params = [ParameterViewModel]()

        for param in parameters {
            guard let paramLocation = param.paramLocation else { continue }
            let viewModel = ParameterViewModel(from: param, with: operation)

            switch paramLocation {
            case .query:
                if param.explode {
//                    {% for param in op.params.explodeQuery.required %}
//                    //    {{ param.value}}.forEach {
//                    //        queryParams.append("{{ param.key }}", $0)
//                    //    }
//                    {% endfor %}
//                    viewModel.optional ? explodeQuery.optional.append(viewModel) : explodeQuery.required
//                        .append(viewModel)
                    assertionFailure("Re-enable explode query.")
                } else {
                    params.append(viewModel)
                }
            case .header, .path, .uri:
                params.append(viewModel)

            case .body:
                // TODO: Body params are handled differently and shouldn't go into RequestParameters at this time
                // We may be able to refactor and change this.
                continue
            default:
                continue
            }
        }

        // TODO: re-evaluate and restore
//        for param in params where param.needDecodingInMethod {
//            methodDecoding.append(param)
//        }

        // Set the body param, if applicable
        var bodyParamName: String?
        let bodyParams = params.filter { $0.location == "body" }
        assert(bodyParams.count <= 1, "Expected, at most, one body parameter.")
        if bodyParams.count > 0 {
            bodyParamName = bodyParams.first?.name
        } else {
            bodyParamName = operation.request?.bodyParamName(for: operation)
        }
        if let bodyParam = operation.request?.bodyParam {
            self.body = BodyParams(
                from: bodyParam,
                parameters: parameters
            )
            // update the body param name to fit Swift conventions
            body?.param.name = bodyParamName ?? "__NONAME__"
        } else {
            self.body = nil
        }

        var signatureViewModel = [ParameterViewModel]()
        for param in parameters.inSignature {
            signatureViewModel.append(ParameterViewModel(from: param))
        }
        self.all = params
        self.signature = signatureViewModel
        if operation.name == "PutBigDecimalNegativeDecimal" {
            let bparam = operation.request?.bodyParam
            let test = "best"
        }
    }
}

enum BodyParamStrategy: String {
    case plain
    case flattened
    case unixTime
    case plainNullable
    case byteArray
    case constant
    case decimal
    case data
    case string
    case date
    case dateTime
    case dateTimeRfc1123
}

struct BodyParams {
    var param: ParameterViewModel
    let strategy: String
    let children: [VirtualParam]

    var flattened: Bool {
        return !children.isEmpty
    }

    init(from param: ParameterType, parameters: [ParameterType]) {
        self.param = ParameterViewModel(from: param)
        var properties = param.schema.properties
        if let objectSchema = param.schema as? ObjectSchema {
            properties = objectSchema.flattenedProperties
        }
        var virtParams = [VirtualParam]()
        for child in properties ?? [] {
            guard child.schema as? ConstantSchema == nil else { continue }
            if let virtParam = parameters.virtual.first(where: { $0.name == child.name }) {
                virtParams.append(VirtualParam(from: virtParam))
            }
        }
        var strategy: BodyParamStrategy = .plain

        if param.flattened {
            strategy = .flattened
        } else if param.nullable {
            strategy = .plainNullable
        } else if param.schema is ConstantSchema {
            strategy = .constant
        } else {
            strategy = param.schema.bodyParamStrategy
        }

        self.strategy = strategy.rawValue
        self.children = virtParams
    }
}

struct VirtualParam {
    var name: String
    var type: String
    var defaultValue: String
    var path: String

    init(from param: VirtualParameter) {
        self.name = param.name
        var path = param.targetProperty.name
        if let groupBy = param.groupedBy?.name {
            path = "\(groupBy).\(path)"
        }
        self.path = path
        self.type = param.schema!.swiftType(optional: !param.required)
        self.defaultValue = param.required ? "" : " = nil"
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
        if let bodyParam = self.params.body {
            if !bodyParam.flattened,
                bodyParam.strategy != BodyParamStrategy.constant.rawValue {
                signatureComments.append("   - \(bodyParam.param.name) : \(bodyParam.param.comment.withoutPrefix)")
            }
        }
        for param in params.inSignature where param.description != "" {
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
