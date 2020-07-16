//
//  SerializationFormats.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Custom extensible metadata for individual serialization formats
public struct SerializationFormats: Codable {
    public let json: SerializationFormat?

    public let xml: XmlSerializationFormat?

    public let protobuf: SerializationFormat?

    public let binary: SerializationFormat?
}
