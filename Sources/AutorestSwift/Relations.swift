//
//  Relations.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct Relations: CodeModelProperty {
    public let properties:RelationsProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct RelationsProperties: CodeModelPropertyBundle {
    public let immediate: [ComplexSchema]

    public let all: [ComplexSchema]
}
