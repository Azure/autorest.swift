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

/// View Model for the method request creation.
struct RequestViewModel {
    let path: String
    let method: String
    let knownMediaType: String?
    let uri: String?
    let mediaTypes: [String]?
    let objectType: String?
    let objectName: String?
    let hasBody: Bool

    init(from request: Request) {
        // load HttpRequest properties
        let httpRequest = request.protocol.http as? HttpRequest
        self.path = httpRequest?.path ?? ""
        self.method = httpRequest?.method.rawValue ?? ""
        self.uri = httpRequest?.uri ?? ""

        // load HttpWithBodyRequest specfic properties
        let httpWithBodyRequest = request.protocol.http as? HttpWithBodyRequest
        self.mediaTypes = httpWithBodyRequest?.mediaTypes ?? []
        self.knownMediaType = httpWithBodyRequest?.knownMediaType.rawValue ?? ""

        // TODO: only support the first signature parameter in Reqest now
        let bodyParams = getBodyParameters(signatureParameters: request.signatureParameters)
        assert(bodyParams.count <= 1, "Unexpectedly found more than 1 body parameters in request... \(request.name)")

        let bodyParam = bodyParams.first
        self.objectType = bodyParam?.schema.name
        if belongsInSignature(param: bodyParam) {
            self.objectName = bodyParam?.name
        } else {
            self.objectName = "options?.\(bodyParam?.name ?? "")"
        }
        self.hasBody = objectType != nil
    }
}

private func getBodyParameters(signatureParameters: [Parameter]?) -> [Parameter] {
    var bodyParameters = [Parameter]()
    for param in signatureParameters ?? [] {
        if let httpParam = param.protocol.http as? HttpParameter,
            httpParam.in == .body {
            bodyParameters.append(param)
        }
    }
    return bodyParameters
}

private func belongsInSignature(param: Parameter?) -> Bool {
    guard let httpParam = param?.protocol.http as? HttpParameter else { return false }

    let required: [ParameterLocation] = [.path, .uri, .body]
    return required.contains(httpParam.in)
}
