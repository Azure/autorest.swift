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

class Request: Metadata {
    /// the parameter inputs to the operation
    let parameters: [ParameterType]?

    /// a filtered list of parameters that is (assumably) the actual method signature parameters
    let signatureParameters: [ParameterType]?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case parameters, signatureParameters
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.parameters = try? container.decode([ParameterType]?.self, forKey: .parameters)
        self.signatureParameters = try? container.decode([ParameterType]?.self, forKey: .signatureParameters)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if parameters != nil { try? container.encode(parameters, forKey: .parameters) }
        if signatureParameters != nil { try? container.encode(signatureParameters, forKey: .signatureParameters) }
        try super.encode(to: encoder)
    }

    /// Lookup a parameter by name.
    func parameter(for name: String) -> ParameterType? {
        return parameters?.first(named: name)
    }
}

extension Request {
    /// Retrieves a single body-encoded parameter, if there is one. Fails if there is more than one.
    var bodyParam: ParameterType? {
        // using a dictionary allows us to eliminate duplicates in a rudimentary fashion. A Set<T> would be
        // better, but requires model class to conform to Hashable
        var bodyParams = [String: ParameterType]()
        for param in signatureParameters ?? [] {
            if case let ParameterType.virtual(virtParam) = param {
                let originalParam = ParameterType.regular(virtParam.originalParameter)
                bodyParams[originalParam.name] = originalParam
            }
            if let httpParam = param.protocol.http as? HttpParameter,
                httpParam.in == .body {
                bodyParams[param.name] = param
            }
        }
        // current logic only supports a single request per operation
        assert(bodyParams.count <= 1, "Unexpectedly found more than 1 body parameters in request... \(name)")
        return Array(bodyParams.values).first
    }

    /// Return a unique list of all `ParameterType` objects.
    var allParams: [ParameterType] {
        let paramList = (signatureParameters ?? []) + (parameters ?? [])
        var params = [String: ParameterType]()
        for param in paramList {
            params[param.name] = param
        }
        return Array(params.values)
    }

    /// Gets the Swift name for the body-encoded parameter, if there is one. Fails if there is more than one.
    func bodyParamName(for operation: Operation) -> String? {
        guard bodyParam != nil else { return nil }
        let operationNameComps = operation.name.splitAndJoinAcronyms
        var bodyParamNameComps = Array(operationNameComps[1 ..< operationNameComps.count])
        for (index, comp) in bodyParamNameComps.enumerated() where index != 0 {
            bodyParamNameComps[index] = comp.capitalized
        }
        return bodyParamNameComps.joined()
    }
}
