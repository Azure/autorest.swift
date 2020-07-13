//
//  SerializationFormat.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public struct SerializationFormat: CodeModelProperty {
    public let properties: SerializationFormatProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct SerializationFormatProperties: CodeModelPropertyBundle {
    public let extensions: Dictionary<AnyHashable, Codable>?
}
