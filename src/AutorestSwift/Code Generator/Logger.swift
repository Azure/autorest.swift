//
//  Logger.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation
import os.log

class Logger {

    // MARK: Properties

    let name: String

    var loggers: [String: OSLog]

    // MARK: Initializers

    init(withName name: String) {
        self.name = name
        loggers = [String: OSLog]()
    }

    // MARK: Methods

    func log(_ message: @autoclosure @escaping () -> String?, category: String = "default", level: OSLogType = .default) {
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
