import Foundation
import NIO
import os.log

class AutoRestHandler {
    // MARK: Properties

    public let plugin: AutoRestPlugin

    private var logger: Logger {
        return plugin.logger
    }

    public var switchMode: SwitchMode?

    // MARK: Initializers

    public init(withPlugin plugin: AutoRestPlugin) {
        self.plugin = plugin
        self.switchMode = nil
    }

    // MARK: Methods

    func handle(context: ChannelHandlerContext, method: String, params: RPCObject, callback: (RPCResult) -> Void) {
        switch method.lowercased() {
        case "getpluginnames":
            callback(
                .success(.list([.string("swift")]))
            )
        case "process":
            plugin.sessionId = params.asList?.last?.asString ?? ""

            logger.logToURL("process get \(plugin.sessionId)")
            // Comment out sending back Process response for now as this will stop AutoRest for some reason.
            /*  callback(
                 .success(.bool(true))
             ) */
            switchMode?(context)
        default:
            callback(.failure(RPCError(kind: .invalidMethod)))
            logger.logToURL("invalid method: \(method)")
        }
    }

    func initializationComplete(context: ChannelHandlerContext) {
        logger.logToURL("initializationComplete")

        guard let sessionId = plugin.sessionId else { fatalError() }
        let listInputsRequest: RPCObject = .list([.string(sessionId), .string("code-model-v4")])
        let future = try? plugin.call(context: context, method: "ListInputs", params: listInputsRequest)

        future?.whenSuccess { result in
            switch result {
            case let .success(response):
                self.handleListInputsResponse(response: response, context: context)
            case let .failure(error):
                self.logger.logToURL("failed with \(error)")
            }
        }

        future?.whenFailure { error in
            self.logger.logToURL("ListInputs call failed: \(error)")
        }
    }

    func handleListInputsResponse(response: RPCObject, context: ChannelHandlerContext) {
        logger.logToURL("List Inputs \(response)")
        guard let sessionId = plugin.sessionId else { fatalError() }
        let filename = response.asList?.first?.asString ?? ""
        let readFileRequest: RPCObject = .list([.string(sessionId), .string(filename)])
        let future = try? plugin.call(context: context, method: "ReadFile", params: readFileRequest)

        future?.whenSuccess { result in
            switch result {
            case let .success(response):
                self.logger.logToURL("\(response)")
            case let .failure(error):
                self.logger.logToURL("failed with \(error)")
            }
        }

        future?.whenFailure { error in
            self.logger.logToURL("ReadFile call failed: \(error)")
        }
    }
}
