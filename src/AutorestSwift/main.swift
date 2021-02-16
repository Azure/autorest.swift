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

let arguments = CommandLineArguments()
let logLevel = LogLevel.info

let yamlFileName = arguments["--input-file"] ?? "code-model-v4.yaml"
let standalone = arguments["--standalone"] != nil

if standalone {
    guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    else { fatalError("Unable to find Documents directory.") }

    let sourceUrl = documentsUrl.appendingPathComponent(yamlFileName)
    do {
        SharedLogger.set(logger: StdoutLogger(), withLevel: logLevel)

        let manager = try Manager(withInputUrl: sourceUrl, destinationUrl: documentsUrl)
        try manager.run()
    } catch {
        SharedLogger.error("\(error)")
    }
} else {
    // Enable file logging
    SharedLogger.set(logger: FileLogger(withFileName: "autorest-swift-debug.log"), withLevel: logLevel)

    let plugin = AutorestPlugin()
    plugin.start()
}
