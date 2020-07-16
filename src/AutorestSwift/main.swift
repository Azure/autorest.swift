import Foundation
import Yams

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
else { fatalError("Unable to find Documents directory.") }
let url = documentsUrl.appendingPathComponent("code-model-v4-no-tags.yaml")
do {
    let yamlString = try String(contentsOf: url)
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
