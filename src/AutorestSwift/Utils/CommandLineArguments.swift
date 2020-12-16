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

class CommandLineArguments {
    let name: String

    let data: [String: String]

    // MARK: Initializers

    init() {
        guard let name = CommandLine.arguments.first else {
            fatalError("Unable to parse command line.")
        }
        let args = CommandLine.arguments.dropFirst().flatMap { $0.split(separator: "=", maxSplits: 1) }
            .map { String($0) }
        var argsDict = [String: String]()
        var index = 0
        while index < args.count {
            let nextIndex = index + 1
            let option = String(args[index])
            guard option.starts(with: "-") else {
                fatalError("Expected option starting with `-` or `--`.")
            }
            if nextIndex == args.count || args[nextIndex].starts(with: "-") {
                // treat this like a flag
                argsDict[option] = ""
                index += 1
            } else {
                // treat this like a single-value option
                argsDict[option] = args[nextIndex]
                index += 2
            }
        }
        self.name = name
        self.data = argsDict
    }

    subscript(index: String) -> String? {
        return data[index]
    }
}
