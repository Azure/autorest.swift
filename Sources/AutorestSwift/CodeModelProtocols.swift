//
//  File.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

// TODO: Make Codable?
public protocol CodeModelProperty {
    // MARK: Properties
    //var properties: CodeModelPropertyBundle { get }
    var defaultProperties: [String] { get }
    var additionalProperties: Bool { get }
}

// TODO: Make Codable?
public protocol CodeModelPropertyBundle {}
