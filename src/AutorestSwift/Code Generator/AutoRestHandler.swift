import Foundation
import NIO
import os.log

class AutoRestHandler {
    // MARK: Properties

    private let plugin: AutoRestPlugin
    private var logger: Logger {
        return plugin.logger
    }

    // MARK: Initializers

    public init(withPlugin plugin: AutoRestPlugin) {
        self.plugin = plugin
    }

    // MARK: Methods

    func handle(method: String, params: RPCObject, callback: (RPCResult) -> Void) {
        switch method.lowercased() {
        case "getpluginnames":
            callback(
                .success(.list([.string("swift")]), .response, "")
            )
        case "process":
            plugin.sessionId = params.asList?.last?.asString ?? ""
            callback(
                .success(.bool(true), .response, "")
            )
            initializationComplete()
        default:
            callback(.failure(RPCError(.invalidMethod)))
            logger.logToURL("invalid method: \(method)")
        }
    }

    func initializationComplete() {
        guard let sessionId = plugin.sessionId else { fatalError() }
        let listInputsRequest: RPCObject = .list([.string(sessionId), .string("code-model-v4")])
        plugin.call(method: "ListInputs", params: listInputsRequest)
        // TODO: Retrieve the code model filename
        let filename = "code-model-v4.yaml"

        let readFileRequest: RPCObject = .list([.string(sessionId), .string(filename)])
        plugin.call(method: "ReadFile", params: readFileRequest)
        // TODO: Retrieve the code model contents
        let codeModelString = "..."

        // TODO: Run through AutoRest.Swift and then make WriteFile requests
    }
}
