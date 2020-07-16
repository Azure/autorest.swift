import Foundation
import Yams

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
else { fatalError("Unable to find Documents directory.") }
let url = documentsUrl.appendingPathComponent("code-model-v4-2.yaml")
do {
    let yamlString = try String(contentsOf: url)
//    if let yamlNode = try Yams.compose(yaml: yamlString) {
//        let codeModel = try decodeCodeModel(fromYamlNode: yamlNode)
//    }
    let decoder = YAMLDecoder()
    let model = try decoder.decode(CodeModel.self, from: yamlString)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let jsonData = try encoder.encode(model)

    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }
} catch {
    print(error)
}

internal func decodeCodeModel(fromYamlNode node: Node) throws -> CodeModel {
    let nodeString = try Yams.serialize(node: node)
    print(nodeString)
    let codeModel = try YAMLDecoder().decode(CodeModel.self, from: nodeString)
    return codeModel
}
