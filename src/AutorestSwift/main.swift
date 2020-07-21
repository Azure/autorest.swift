import Foundation
import os.log

guard let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
    fatalError("Unabled to locate Documents directory.")
}
let sourceUrl = documentsUrl.appendingPathComponent("code-model-v4-2.yaml")
let manager = Manager(withInputUrl: sourceUrl, destinationUrl: documentsUrl)
do {
    try manager.run()
} catch {
    print(error)
}
