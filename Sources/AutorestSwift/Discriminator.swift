//
//  Discriminator.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct Discriminator: CodeModelProperty {
    public let properties: DiscriminatorProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct DiscriminatorProperties: CodeModelPropertyBundle {
    public let property: Property

    public let immediate: ComplexSchema
    
    public let all: ComplexSchema
}
