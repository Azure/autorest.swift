//
//  XmlSerializationFormat.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public typealias XmlSerializationFormat = Compose<XmlSerializationFormatProperty, SerializationFormat>

public struct XmlSerializationFormatProperty: Codable {
    public let name: String?

    public let namespace: String?

    public let prefix: String?

    public let attribute: Bool

    public let wrapped: Bool
}
