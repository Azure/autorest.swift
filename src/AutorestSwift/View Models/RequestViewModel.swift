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
    let params: [ParameterViewModel]?
    let objectType: String?

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

        // check if the request body is from signature parameter. If yes, store the object type
        // and add the request signature parameter to operation parameters
        var params = [ParameterViewModel]()
        for param in request.signatureParameters ?? [] {
            params.append(ParameterViewModel(from: param))
        }
        self.params = params

        self.objectType = request.signatureParameters?.first?.schema.name
    }
}
