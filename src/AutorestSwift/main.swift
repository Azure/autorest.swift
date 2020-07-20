import Foundation
import Yams

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
else { fatalError("Unable to find Documents directory.") }

let sourceUrl = documentsUrl.appendingPathComponent("code-model-v4-2.yaml")
let beforeJsonUrl = documentsUrl.appendingPathComponent("before.json")
let afterJsonUrl = documentsUrl.appendingPathComponent("after.json")

do {
    var yamlString = try String(contentsOf: sourceUrl)

    // TODO: Remove when issue (https://github.com/Azure/autorest.swift/issues/47) is fixed. Replaces empty string with a single space.
    yamlString = yamlString.replacingOccurrences(of: ": ''", with: ": ' '")

    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

    // convert YAML to JSON and save as before
    if let beforeJson = try Yams.load(yaml: yamlString) {
        let beforeJsonData = try JSONSerialization.data(
            withJSONObject: beforeJson,
            options: [.sortedKeys, .prettyPrinted]
        )
        try beforeJsonData.write(to: beforeJsonUrl)
    }

    // decode YAML to model
    let decoder = YAMLDecoder()
    let model = try decoder.decode(CodeModel.self, from: yamlString)

    // convert model to JSON
    let afterJsonData = try encoder.encode(model)
    try afterJsonData.write(to: afterJsonUrl)
} catch {
    print(error)
}

internal func decodeCodeModel(fromYamlNode node: Node) throws -> CodeModel {
    let nodeString = try Yams.serialize(node: node)
    print(nodeString)
    let codeModel = try YAMLDecoder().decode(CodeModel.self, from: nodeString)
    return codeModel
}
