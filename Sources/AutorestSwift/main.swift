import Foundation
import Yams

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Unable to find Documents directory.") }
let url = documentsUrl.appendingPathComponent("code-model-v4-no-tags.yaml")
do {
    let yamlString = try String(contentsOf: url)
    let decoder = YAMLDecoder()
    let model = try decoder.decode(CodeModel.self, from: yamlString)
    print(model)
} catch {
    print(error)
}
