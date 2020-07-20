//
//  SchemaResponse.swift
//
//
//  Created by Travis Prescott on 7/17/20.
//

import Foundation

/// a response that should be deserialized into a result of type(schema)
public class SchemaResponse: Response {
    /// the content returned by the service for a given operation
    public let schema: Schema

    /// indicates whether the response can be 'null'
    public let nullable: Bool?

    public enum CodingKeys: String, CodingKey {
        case schema, nullable
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let arraySchema = try? container.decode(ArraySchema.self, forKey: .schema) {
            self.schema = arraySchema
        } else {
            self.schema = try container.decode(Schema.self, forKey: .schema)
        }
        self.nullable = try? container.decode(Bool.self, forKey: .nullable)

        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(schema, forKey: .schema)
        if nullable != nil { try container.encode(nullable, forKey: .nullable) }

        try super.encode(to: encoder)
    }
}
