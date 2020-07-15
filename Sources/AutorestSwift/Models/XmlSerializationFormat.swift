//
//  XmlSerializationFormat.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public struct XmlSerializationFormat: Codable {
    public let name: String?

    public let namespace: String?

    public let prefix: String?

    public let attribute: Bool

    public let wrapped: Bool

    // TODO: Apply allOf
    // public let allOf: [SerializationFormat]
}
