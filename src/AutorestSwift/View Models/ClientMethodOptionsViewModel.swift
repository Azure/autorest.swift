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

/// View Model for an individual client method Options object.
struct ClientMethodOptionsViewModel {
    /// The name of the client class (i.e. AzureStorageBlob)
    let clientName: String

    /// The name of the operation (i.e. listContainers)
    let operationName: String

    /// The name of the options object (i.e. ListContainersOptions)
    let name: String

    // The list of properites for the options object
    let properties: [PropertyViewModel]

    let extensionName: String

    init(from operation: Operation, with model: CodeModel, parameters: [ParameterType], groupName: String) {
        self.clientName = model.name
        self.operationName = operation.name
        self.name = "\(operation.name)Options"
        if model.object(for: groupName) != nil {
            self.extensionName = groupName + "Operation"
        } else {
            self.extensionName = groupName
        }
        var properties = [PropertyViewModel]()

        // In generated code stencil, there is already a 'clientRequestId', so do not duplicate by adding anyone with same name
        for parameter in parameters where parameter.value.name != "clientRequestId" {
            properties.append(PropertyViewModel(from: parameter.value))
        }

        // For `Options` Group schema created by "x-ms-parameter-grouping" with postfix: Options,
        // add all the properties from that group schema except property in path as the properties of the Method Option object
        if let group = model.schemas.schema(for: groupName + name, withType: .group),
            group.name.hasSuffix("Options") {
            for property in group.properties ?? [] {
                switch property {
                case let .grouped(groupProperty):
                    for param in groupProperty.originalParameter where param.paramLocation != .path {
                        properties.append(PropertyViewModel(from: property.value))
                    }
                default:
                    continue
                }
            }
        }

        self.properties = properties
    }
}
