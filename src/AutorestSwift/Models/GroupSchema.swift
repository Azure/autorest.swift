//
//  GroupSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public class GroupSchema: Schema {

    // Mark: allOf SchemaUsage
   /// contexts in which the schema is used
   public let usage: [SchemaContext]

   /// Known media types in which this schema can be serialized
   public let serializationFormats: [KnownMediaType]
    
     enum CodingKeys: String, CodingKey {
    case usage, serializationFormats
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    usage = try container.decode( [SchemaContext].self, forKey: .usage)
    serializationFormats = try container.decode( [KnownMediaType].self, forKey: .serializationFormats)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(usage, forKey: .usage)
    try container.encode(serializationFormats, forKey: .serializationFormats)
     try super.encode(to: encoder)
    }
}
