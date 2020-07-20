//
//  XmlSerializationFormat.swift
//
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

public class XmlSerializationFormat: SerializationFormat {
    public let name: String?

    public let namespace: String?

    public let prefix: String?

    public let attribute: Bool

    public let wrapped: Bool
    
     enum CodingKeys: String, CodingKey {
    case name, namespace, prefix, attribute, wrapped
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try? container.decode( String?.self, forKey: .name)
    namespace = try? container.decode( String?.self, forKey: .namespace)
    prefix = try? container.decode( String?.self, forKey: .prefix)
    attribute = try container.decode( Bool.self, forKey: .attribute)
    wrapped = try container.decode( Bool.self, forKey: .wrapped)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if name != nil { try? container.encode(name, forKey: .name)}
    if namespace != nil { try? container.encode(namespace, forKey: .namespace)}
    if prefix != nil { try? container.encode(prefix, forKey: .prefix)}
    try container.encode(attribute, forKey: .attribute)
    try container.encode(wrapped, forKey: .wrapped)
     try super.encode(to: encoder)
    }
}
