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

enum LogLevel: Int {
    case error, warning, info, debug

    var asOSLogLevel: OSLogType {
        switch self {
        case .error:
            return OSLogType.error
        case .warning:
            fallthrough
        case .info:
            return OSLogType.info
        case .debug:
            return OSLogType.debug
        default:
            return OSLogType.default
        }
    }

    var label: String {
        switch self {
        case .error:
            return "ERROR"
        case .warning:
            return "WARN"
        case .info:
            return "INFO"
        case .debug:
            return "DEBUG"
        default:
            return "UNK"
        }
    }
}

protocol Logger {
    var level: LogLevel { get set }

    func log(_ message: @autoclosure @escaping () -> String?, category: String?, level: LogLevel)
    func fail(_ message: @autoclosure @escaping () -> String?, category: String?) -> Never
}

extension Logger {
    func shouldLog(forLevel level: LogLevel) -> Bool {
        return level.rawValue <= self.level.rawValue
    }
}

// MARK: - Implementation

struct SharedLogger {
    private static var logger: Logger!

    fileprivate static let `default` = "default"

    static func set(logger: Logger) {
        SharedLogger.logger = logger
    }

    static func error(
        _ message: @autoclosure @escaping () -> String?,
        category: String? = nil
    ) {
        log(message(), category: category, level: .error)
    }

    static func warn(
        _ message: @autoclosure @escaping () -> String?,
        category: String? = nil
    ) {
        log(message(), category: category, level: .warning)
    }

    static func info(
        _ message: @autoclosure @escaping () -> String?,
        category: String? = nil
    ) {
        log(message(), category: category, level: .info)
    }

    static func debug(
        _ message: @autoclosure @escaping () -> String?,
        category: String? = nil
    ) {
        log(message(), category: category, level: .debug)
    }

    private static func log(
        _ message: @autoclosure @escaping () -> String?,
        category: String? = nil,
        level: LogLevel
    ) {
        guard logger.shouldLog(forLevel: level) else { return }
        SharedLogger.logger.log(message(), category: category ?? SharedLogger.default, level: level)
    }

    static func fail(
        _ message: @autoclosure @escaping () -> String?,
        category: String = SharedLogger.default
    ) -> Never {
        SharedLogger.logger.fail(message(), category: category)
    }
}

/// Do-nothing logger
class NullLogger: Logger {
    var level: LogLevel = .info

    func log(_: @autoclosure @escaping () -> String?, category _: String? = nil, level _: LogLevel = .info) {}

    func fail(_: @autoclosure @escaping () -> String?, category _: String? = nil) -> Never {
        fatalError()
    }
}

/// OSX-specific OS logger
class OSLogger: Logger {
    // MARK: Properties

    var level: LogLevel = .info

    let name: String
    var loggers: [String: OSLog]

    // MARK: Initializers

    init(withName name: String) {
        self.name = name
        self.loggers = [String: OSLog]()
    }

    // MARK: Methods

    func log(_ message: @autoclosure @escaping () -> String?, category: String? = nil, level: LogLevel) {
        guard let msg = message() else {
            fatalError("Unable to create log message.")
        }
        guard shouldLog(forLevel: level) else { return }
        let cat = category ?? SharedLogger.default
        if let logger = loggers[cat] {
            os_log("%@", log: logger, type: level.asOSLogLevel, msg)
        } else {
            let logger = OSLog(subsystem: name, category: cat)
            loggers[cat] = logger
            os_log("%@", log: logger, type: level.asOSLogLevel, msg)
        }
    }

    func fail(_ message: @autoclosure @escaping () -> String?, category: String? = nil) -> Never {
        guard let msg = message() else {
            fatalError("Unable to create log message.")
        }
        log(msg, category: category, level: .error)
        fatalError(msg)
    }
}

/// Cross-platform Swift logger implementation
class SwiftLogger: Logger {
    var level: LogLevel = .info

    func log(
        _ message: @autoclosure @escaping () -> String?,
        category _: String? = nil,
        level _: LogLevel
    ) {
        guard let msg = message() else {
            fatalError("Unable to create log message.")
        }
        guard shouldLog(forLevel: level) else { return }
        // TODO: Implement
    }

    func fail(_ message: @autoclosure @escaping () -> String?, category _: String? = nil) -> Never {
        guard let msg = message() else {
            fatalError("Unable to create log message.")
        }
        // TODO: Implement
        fatalError(msg)
    }
}

/// Logs to a file.
class FileLogger: Logger {
    var level: LogLevel = .info

    func log(_ message: @autoclosure @escaping () -> String?, category: String? = nil, level: LogLevel) {
        guard var msg = message() else {
            fatalError("Unable to create log message.")
        }
        guard shouldLog(forLevel: level) else { return }
        if let cat = category {
            msg = "AutorestSwift.\(cat) (\(level.label)) \(msg)"
        } else {
            msg = "AutorestSwift (\(level.label)) \(msg)"
        }
        try? url.append(line: msg)
    }

    func fail(_ message: @autoclosure @escaping () -> String?, category: String? = nil) -> Never {
        guard let msg = message() else {
            fatalError("Unable to create log message.")
        }
        log(msg, category: category, level: .error)
        fatalError(msg)
    }

    // MARK: Properties

    let url: URL

    // MARK: Initializers

    internal init(withFileName name: String, deleteIfExists: Bool = true) {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to locate Documents directory.")
        }
        self.url = documentsUrl.appendingPathComponent(name)
        if deleteIfExists {
            try? FileManager.default.removeItem(atPath: url.path)
        }
    }
}
