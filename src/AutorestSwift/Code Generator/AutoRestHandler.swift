import Foundation
import NIO
import os.log

class AutoRestHandler {
    private let logger: Logger

    init() {
        self.logger = Logger(withFileName: "autorest-swift-debug.log")
    }

    func handle(method: String, params _: RPCObject, callback: (RPCResult) -> Void) {
        switch method.lowercased() {
        case "getpluginnames":
            logger.logToURL("Get a getpluginnames request")
            return callback(.success(.list([.string("swift")]), RPCObjectType.response, ""))

        case "process":
            logger.logToURL("Get a process request")

            let sessionId = "session_7"

            logger.logToURL("Send back a process response")
            callback(.success(.bool(true), RPCObjectType.response, ""))

            logger.logToURL("Send a ListInputs request")
            return callback(.success(
                .list([.string(sessionId), .string("code-model-v4")]),
                RPCObjectType.request,
                "ListInputs"
            ))
        default:
            callback(.failure(RPCError(.invalidMethod)))
            logger.logToURL("invalid method: \(method)")
        }
    }
}
