//
//  FlagSchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct FlagSchema: Codable {
    /// the possible choices for in the set
    public let choices: [FlagValue]
    
    // TODO: Apply allOf
    // public let allOf: [ValueSchema]
}
