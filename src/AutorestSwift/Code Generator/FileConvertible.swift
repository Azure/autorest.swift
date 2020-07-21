//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

protocol FileConvertible {
    func toFile(inFolder folder: URL) throws
}
