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

enum BodyParamStrategy: String {
    case plain
    case plainNullable
    case flattened
    case unixTime
    case byteArray
    case constant
    case decimal
    case data
    case string
    case time
}

struct BodyParams {
    /// The `ParameterViewModel` corresponding to the body param
    var param: ParameterViewModel

    /// Identifies the correct snippet to use when rendering the view model
    let strategy: String

    /// A list of `VirtualParam` that correlate to a flattened body parmeter
    let children: [VirtualParam]

    /// Returns `true` if the body parameter is flattened
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
            if strategy == .plain, !param.required {
                strategy = .plainNullable
            }
        }
        self.strategy = strategy.rawValue
        self.children = virtParams
    }
}
