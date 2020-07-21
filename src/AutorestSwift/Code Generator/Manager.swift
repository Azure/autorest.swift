//
//  Manager.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation
import Yams

/// Handles the configuration and orchestrations of the code generation process
class Manager {

    // MARK: Properties

    let inputUrl: URL

    let destinationRootUrl: URL

    lazy var logger = Logger(withName: "Autorest.Swift")

    // MARK: Initializers

    init(withInputUrl input: URL, destinationUrl dest: URL) {
        inputUrl = input
        // TODO: Make this configurable
        destinationRootUrl = dest.appendingPathComponent("generated").appendingPathComponent("sdk")
        ensureExists(folder: destinationRootUrl)
    }

    // MARK: Methods

    func run() throws {
        let model = try loadModel()

        // Determine Swift names for all model objects
        let namer = SwiftNamer(withModel: model)
        try namer.process()

        // Generate Swift code files
        let generator = SwiftGenerator(withModel: model)
        try generator.generate()
    }

    /// Decodes the YAML code model file into Swift objects and evaluates model consistency
    private func loadModel() throws -> CodeModel {

        // decode YAML to model
        let decoder = YAMLDecoder()
        var yamlString = try String(contentsOf: inputUrl)
        // TODO: Remove when issue (https://github.com/Azure/autorest.swift/issues/47) is fixed.
        // Replaces empty string with a single space.
        yamlString = yamlString.replacingOccurrences(of: ": ''", with: ": ' '")
        let model = try decoder.decode(CodeModel.self, from: yamlString)

        check(model: model, against: yamlString)

        return model
    }

    /// Check model for consistency and save debugging files if inconsistent
    private func check(model: CodeModel, against yamlString: String) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

        var beforeJsonString: String? = nil
        var afterJsonString: String? = nil

        // get JSON representation of YAML
        if let beforeJson = try? Yams.load(yaml: yamlString) {
            do {
                let beforeJsonData = try JSONSerialization.data(
                    withJSONObject: beforeJson,
                    options: [.sortedKeys, .prettyPrinted]
                )
                beforeJsonString = String(data: beforeJsonData, encoding: .utf8)
            } catch {
                logger.log(error.localizedDescription, level: .error)
            }
        }

        // convert model to JSON
        if let afterJsonData = try? encoder.encode(model) {
            afterJsonString = String(data: afterJsonData, encoding: .utf8)
        }

        // If JSON strings don't match, there must be a problem in the modeling.
        // Dump both files so they can be diffed.
        if beforeJsonString != afterJsonString {
            let beforeJsonUrl = destinationRootUrl.appendingPathComponent("before.json")
            let afterJsonUrl = destinationRootUrl.appendingPathComponent("after.json")
            do {
                try beforeJsonString?.write(to: beforeJsonUrl, atomically: true, encoding: .utf8)
                try afterJsonString?.write(to: afterJsonUrl, atomically: true, encoding: .utf8)
                logger.log("Discrepancies found in round-tripped code model. Run a diff on 'before.json' and 'after.json' to troubleshoot.")
            } catch {
                logger.log("Discrepancies found in round-tripped code model. Error saving files: \(error.localizedDescription)", level: .error)
            }
        } else if beforeJsonString == nil || afterJsonString == nil {
            logger.log("Errors found trying to decode models. Please check your Swagger file.", level: .error)
        } else {
            logger.log("Model file check: OK", level: .info)
        }
    }

    private func ensureExists(folder: URL) {
        let fileManager = FileManager.default

        if let existing = try? folder.resourceValues(forKeys: [.isDirectoryKey]) {
            if !existing.isDirectory! {
                fatalError("Path exists but is not a folder!")
            }
        } else {
            // Path does not exist so let us create it
            do {
                try fileManager.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
