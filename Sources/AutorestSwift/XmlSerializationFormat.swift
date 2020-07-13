//
//  XmlSerializationFormat.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public struct XmlSerializationFormat: CodeModelProperty {
    public let properties: XmlSerializationFormatProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [SerializationFormat]
}

public struct XmlSerializationFormatProperties: CodeModelPropertyBundle {
    public let name: String?

    public let namespace: String?

    public let prefix: String?

    public let attribute: Bool

    public let wrapped: Bool
}
