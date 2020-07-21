//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

extension URL {
    func ensureExists() throws {
        let fileManager = FileManager.default

        if let existing = try? self.resourceValues(forKeys: [.isDirectoryKey]) {
            if !existing.isDirectory! {
                let err = "Path exists but is not a folder!"
                fatalError(err)
            }
        } else {
            // Path does not exist so let us create it
            try fileManager.createDirectory(atPath: self.path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func with(subfolder: FileDestination) -> URL {
        return subfolder.url(forBaseUrl: self)
    }
}
