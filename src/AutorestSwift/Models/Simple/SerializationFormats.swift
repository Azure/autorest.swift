//
//  SerializationFormats.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Custom extensible metadata for individual serialization formats
public struct SerializationFormats: Codable {
    public var json: SerializationFormat?

    public var xml: XmlSerializationFormat?

    public var protobuf: SerializationFormat?

    public var binary: SerializationFormat?
}
