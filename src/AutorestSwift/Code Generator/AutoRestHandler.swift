import Foundation
import NIO
import os.log

class AutoRestHandler {
    private let log: URL

    init() {
        guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unabled to locate Documents directory.")
        }

        self.log = documentsUrl.appendingPathComponent("autorest-swift.log")
    }

    func handle(method: String, params: RPCObject, callback: (RPCResult) -> Void) {
        switch method.lowercased() {
        case "getpluginnames":

            try? "Get a getpluginnames request".appendLineToURL(fileURL: log)
            return callback(.success(.list([.string("swift")])))

        case "process":
            try? "Get a process request".appendLineToURL(fileURL: log)

            return callback(.success(.bool(true)))
        case "codegen":

            do {
                try? "Get a process request".appendLineToURL(fileURL: log)
                let data = try JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
                try data.appendToURL(fileURL: log)
            } catch {
                try? "Get an \(error)".appendLineToURL(fileURL: log)
            }
        // self.add(params: params, callback: callback)
        default:
            callback(.failure(RPCError(.invalidMethod)))
            try? "invalid metho \(method)".appendLineToURL(fileURL: log)
        }
    }
}
