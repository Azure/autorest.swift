import Foundation
import Yams

guard let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Unable to find Documents directory.") }
let url = documentsUrl.appendingPathComponent("code-model-v4-no-tags.yaml")
do {
    let yamlString = try String(contentsOf: url)
    if let object = try Yams.load(yaml: yamlString) as? Dictionary<String, Any> {
        print(object as AnyObject)
    }
} catch {
    print(error)
}
