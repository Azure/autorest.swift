//
//  XmlSerializationFormat.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public struct XmlSerializationFormat: SerializationFormatProtocol {
    public var name: String?

    public var namespace: String?

    public var prefix: String?

    public var attribute: Bool

    public var wrapped: Bool
}
