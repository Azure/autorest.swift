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

// Drop the first argument as that is the Executable name
let arguments: [String] = Array(CommandLine.arguments.dropFirst())

if arguments.count == 0 {
    // Enable file logging
    SharedLogger.set(logger: FileLogger(withFileName: "autorest-swift-debug.log"))

    let plugin = AutorestPlugin()
    plugin.start()
} else if arguments[0] == "--standalone" {
    guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else { fatalError("Unable to find Documents directory.") }

    let yamlFileName = arguments.count == 2 ? arguments[1] : "code-model-v4-2.yaml"
    let sourceUrl = documentsUrl.appendingPathComponent(yamlFileName)
    do {
        SharedLogger.set(logger: SwiftLogger())

        let manager = try Manager(withInputUrl: sourceUrl, destinationUrl: documentsUrl)
        try manager.run()
    } catch {
        print(error)
    }
}
