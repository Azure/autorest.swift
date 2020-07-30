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

    let properties: [PropertyViewModel]

    init(from operation: Operation, with model: CodeModel) {
        self.clientName = model.name
        self.operationName = operation.name.toCamelCase
        self.name = "\(operation.name.toPascalCase)Options"
        var properties = [PropertyViewModel]()
        for param in operation.signatureParameters ?? [] {
            properties.append(PropertyViewModel(from: param))
        }
        self.properties = properties
    }
}
