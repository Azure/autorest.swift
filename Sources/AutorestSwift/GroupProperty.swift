//
//  GroupProperty.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct GroupProperty: CodeModelProperty {
    public let properties: GroupPropertyProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
    
    public let allOf: [Property]
}

public struct GroupPropertyProperties: CodeModelPropertyBundle {
    public let originalParameter: [Parameter]
}
