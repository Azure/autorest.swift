//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

extension Encodable {
    func prettyPrint() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let jsonData = try? encoder.encode(self) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        }
    }
}
