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
import os.log

class Logger {
    // MARK: Properties

    let name: String

    var loggers: [String: OSLog]

    // MARK: Initializers

    init(withName name: String) {
        self.name = name
        self.loggers = [String: OSLog]()
    }

    // MARK: Methods

    func log(
        _ message: @autoclosure @escaping () -> String?,
        category: String = "default",
        level: OSLogType = .default
    ) {
        guard let msg = message() else {
            os_log("Unable to issue log message")
            return
        }
        if let logger = loggers[category] {
            os_log("%@", log: logger, type: level, msg)
        } else {
            let logger = OSLog(subsystem: name, category: category)
            loggers[category] = logger
            os_log("%@", log: logger, type: level, msg)
        }
    }
}

class FileLogger {
    // MARK: Properties

    let url: URL

    // MARK: Initializers

    init(withFileName name: String) {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to locate Documents directory.")
        }
        self.url = documentsUrl.appendingPathComponent(name)
    }

    // MARK: Methods

    func log(_ message: @autoclosure @escaping () -> String?) {
        guard let msg = message() else {
            return
        }
        try? url.append(line: msg)
    }
}
