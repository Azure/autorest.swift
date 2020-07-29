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

struct ReturnTypeViewModel {
    let name: String

    init(from objectType: String) {
        self.name = objectType
    }
}

struct ParameterViewModel {
    let name: String
    let type: String
    let defaultValue: ViewModelDefault

    init(from schema: Parameter) {
        self.name = schema.name.toCamelCase
        self.type = schema.schema.name
        self.defaultValue = ViewModelDefault(from: schema.clientDefaultValue, isString: true)
    }
}

struct KeyValueViewModel {
    let key: String
    let value: String

    init(from schema: Parameter, signatureParameters params: [ParameterViewModel]) {
        self.key = schema.serializedName!
        self.value = getValue(from: schema, signatureParameters: params)
    }
}

private func getValue(from schema: Parameter, signatureParameters params: [ParameterViewModel]) -> String {
    if let constantSchema = schema.schema as? ConstantSchema {
        return "\"\(constantSchema.value.value)\""
    }

    // check if the name matches with one of the signature parameter
    // if match, the value is taken from the signature parameter
    for param in params where param.name == schema.name {
        return param.name
    }

    return ""
}

struct RequestViewModel {
    let path: String
    let method: String
    let knownMediaType: String?
    let uri: String?
    let mediaTypes: [String]?
    let params: [ParameterViewModel]?
    let objectType: String?

    init(from request: Request) {
        // load HttpRequest properties
        if let httpRequest = (request.protocol.http as? HttpRequest) {
            self.path = httpRequest.path
            self.method = httpRequest.method.rawValue
            self.uri = httpRequest.uri
        } else {
            self.path = ""
            self.method = ""
            self.uri = ""
        }

        // load HttpWithBodyRequest specfic properties
        if let httpWithBodyRequest = (request.protocol.http as? HttpWithBodyRequest) {
            self.mediaTypes = httpWithBodyRequest.mediaTypes
            self.knownMediaType = httpWithBodyRequest.knownMediaType.rawValue
        } else {
            self.mediaTypes = nil
            self.knownMediaType = nil
        }

        // check if the request body is from signature parameter. If yes, store the object type
        // and add the request signature parameter to operation parameters
        var params = [ParameterViewModel]()
        for param in request.signatureParameters ?? [] {
            params.append(ParameterViewModel(from: param))
        }
        self.params = params

        if request.signatureParameters?.count == 1,
            request.signatureParameters?[0].schema.type == AllSchemaTypes.object {
            self.objectType = request.signatureParameters?[0].schema.name
        } else {
            self.objectType = nil
        }
    }
}

struct ResponseViewModel {
    let statusCodes: [String]
    let knownMediaType: String?
    let mediaTypes: [String]?
    let objectType: String?

    init(from response: Response) {
        if let httpResponse = (response.protocol.http as? HttpResponse) {
            var statusCodes = [String]()
            for code in httpResponse.statusCodes {
                statusCodes.append(code.rawValue)
            }
            self.statusCodes = statusCodes
            self.knownMediaType = httpResponse.knownMediaType?.rawValue
            self.mediaTypes = httpResponse.mediaTypes
        } else {
            self.statusCodes = []
            self.knownMediaType = nil
            self.mediaTypes = nil
        }

        // check if the request body schema type is object, store the object type of the response body
        if let schemaResponse = response as? SchemaResponse,
            schemaResponse.schema.type == AllSchemaTypes.object {
            self.objectType = schemaResponse.schema.name
        } else {
            self.objectType = nil
        }
    }
}

struct OperationViewModel {
    let name: String
    let comment: ViewModelComment
    let params: [ParameterViewModel]
    let returnType: ReturnTypeViewModel?
    let queryParams: [KeyValueViewModel]?
    let headerParams: [KeyValueViewModel]?
    let uriParams: [KeyValueViewModel]?
    let requests: [RequestViewModel]?
    let responses: [ResponseViewModel]?
    let method: String?
    let path: String?

    init(from schema: Operation) {
        self.name = operationName(for: schema.name)
        self.comment = ViewModelComment(from: schema.description)

        // operation parameters should be all the signature paramters from the schema
        // and the signature parameters of the Request
        var items = [ParameterViewModel]()
        for param in schema.signatureParameters ?? [] {
            items.append(ParameterViewModel(from: param))
        }

        var queryParams = [KeyValueViewModel]()
        var headerParams = [KeyValueViewModel]()
        var uriParams = [KeyValueViewModel]()

        for param in schema.parameters ?? [] {
            if let httpParam = (param.protocol.http as? HttpParameter?) {
                if httpParam?.in == ParameterLocation.query {
                    queryParams.append(KeyValueViewModel(from: param, signatureParameters: items))
                } else
                if httpParam?.in == ParameterLocation.header {
                    headerParams.append(KeyValueViewModel(from: param, signatureParameters: items))
                } else
                if httpParam?.in == ParameterLocation.uri {
                    uriParams.append(KeyValueViewModel(from: param, signatureParameters: items))
                }
            }
        }

        self.queryParams = queryParams
        self.headerParams = headerParams
        self.uriParams = uriParams

        var requests = [RequestViewModel]()
        var responses = [ResponseViewModel]()

        for request in schema.requests ?? [] {
            requests.append(RequestViewModel(from: request))
        }

        for response in schema.responses ?? [] {
            responses.append(ResponseViewModel(from: response))
        }

        self.requests = requests
        self.responses = responses

        // TODO: only support max 1 request and  max 1 response for now
        if requests.count == 1, responses.count == 1 {
            for param in requests[0].params ?? [] {
                items.append(param)
            }

            self.method = requests[0].method
            self.path = requests[0].path
            self.returnType = ReturnTypeViewModel(from: responses[0].objectType ?? "")
        } else {
            self.method = nil
            self.path = nil
            self.returnType = nil
        }

        self.params = items
    }
}

struct OperationGroupViewModel {
    let name: String
    let operations: [OperationViewModel]

    init(from schema: OperationGroup) {
        self.name = schema.name.toCamelCase
        var items = [OperationViewModel]()
        for operation in schema.operations {
            items.append(OperationViewModel(from: operation))
        }
        self.operations = items
    }
}

struct ServiceClientViewModel {
    let name: String
    let comment: ViewModelComment
    let operationGroups: [OperationGroupViewModel]

    init(from schema: CodeModel) {
        self.name = clientName(for: schema.name)
        self.comment = ViewModelComment(from: schema.description)
        var items = [OperationGroupViewModel]()
        for group in schema.operationGroups {
            items.append(OperationGroupViewModel(from: group))
        }
        self.operationGroups = items
    }
}

private func clientName(for serviceName: String) -> String {
    var name = serviceName
    let stripList = ["Service", "Client"]
    for item in stripList {
        if name.hasSuffix(item) {
            name = String(name.dropLast(item.count))
        }
    }
    return "\(name)Client"
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
