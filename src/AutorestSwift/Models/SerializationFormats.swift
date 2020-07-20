//
//  SerializationFormats.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Custom extensible metadata for individual serialization formats
public class SerializationFormats: Codable {
    public let json: SerializationFormat?

    public let xml: XmlSerializationFormat?

    public let protobuf: SerializationFormat?

    public let binary: SerializationFormat?
    
     enum CodingKeys: String, CodingKey {
    case json, xml, protobuf, binary
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    json = try? container.decode( SerializationFormat?.self, forKey: .json)
    xml = try? container.decode( XmlSerializationFormat?.self, forKey: .xml)
    protobuf = try? container.decode( SerializationFormat?.self, forKey: .protobuf)
    binary = try? container.decode( SerializationFormat?.self, forKey: .binary)

    }
    public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if json != nil { try? container.encode(json, forKey: .json)}
    if xml != nil { try? container.encode(xml, forKey: .xml)}
    if protobuf != nil { try? container.encode(protobuf, forKey: .protobuf)}
    if binary != nil { try? container.encode(binary, forKey: .binary)}

    }
}
