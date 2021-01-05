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
    let all: [ParameterViewModel]
    let signature: [ParameterViewModel]
    let explode: [ParameterViewModel]
    var body: BodyParams?
    var declaration: String

    /// Initialize with a list of `ParameterType`.
    init(parameters: [ParameterType], operation: Operation, model: CodeModel) {
        var params = [ParameterViewModel]()
        var explodeParams = [ParameterViewModel]()

        for param in parameters {
            guard let paramLocation = param.paramLocation else { continue }
            let viewModel = ParameterViewModel(from: param, with: operation)

            switch paramLocation {
            case .query:
                if param.explode {
                    explodeParams.append(viewModel)
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
            body?.param.name = bodyParamName ?? bodyParam.name
        } else {
            self.body = nil
        }

        var signatureViewModel = [ParameterViewModel]()
        for param in parameters {
            // For `Options` Group schema created by "x-ms-parameter-grouping" with postfix: Options,
            // look for  all the properties from that group schema which is in 'path' as the signature of the method
            if let group = model.schemas.schema(for: param.name, withType: .group) as? GroupSchema,
                group.name.hasSuffix("Options") {
                for property in group.properties ?? [] {
                    switch property {
                    case let .grouped(groupProperty):
                        for param in groupProperty.originalParameter where param.paramLocation == .path {
                            signatureViewModel.append(ParameterViewModel(from: param))
                        }
                    default:
                        continue
                    }
                }
            } else if param.belongsInSignature(model: model) {
                signatureViewModel.append(ParameterViewModel(from: param))
            }
        }
        self.all = params
        self.signature = signatureViewModel
        self.explode = explodeParams
        self.declaration = explode.isEmpty ? "let" : "var"
    }
}
