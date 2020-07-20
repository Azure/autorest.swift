//
//  Property.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// a property is a child value in an object
public class Property: Value {
    // if the property is marked read-only (ie, not intended to be sent to the service)
    public let readOnly: Bool?

    // the wire name of this property
    public let serializedName: String

    // when a property is flattened, the property will be the set of serialized names to get to that target property. If flattenedName is present, then this property is a flattened property. (ie, ['properties','name'] )
    public let flattenedNames: [String]?

    // if this property is used as a discriminator for a polymorphic type
    public let isDiscriminator: Bool?

    public enum CodingKeys: String, CodingKey {
        case readOnly, serializedName, flattenedNames, isDiscriminator, schema
    }

    // MARK: Codable

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.readOnly = try? container.decode(Bool.self, forKey: .readOnly)
        self.serializedName = try container.decode(String.self, forKey: .serializedName)
        self.flattenedNames = try? container.decode([String].self, forKey: .flattenedNames)
        self.isDiscriminator = try? container.decode(Bool.self, forKey: .isDiscriminator)

        try super.init(from: decoder)

        if let arraySchema = try? container.decode(ArraySchema.self, forKey: .schema) {
            super.schema = arraySchema
        } else if let numberSchema = try? container.decode(NumberSchema.self, forKey: .schema) {
            super.schema = numberSchema
        } else if let choiceSchema = try? container.decode(ChoiceSchema.self, forKey: .schema) {
            super.schema = choiceSchema
        } else if let dateTimeSchema = try? container.decode(DateTimeSchema.self, forKey: .schema) {
            super.schema = dateTimeSchema
        } else if let stringSchema = try? container.decode(StringSchema.self, forKey: .schema) {
            super.schema = stringSchema
        } else {
            super.schema = try container.decode(Schema.self, forKey: .schema)
        }
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        if readOnly != nil { try container.encode(readOnly, forKey: .readOnly) }
        try container.encode(serializedName, forKey: .serializedName)
        if flattenedNames != nil { try container.encode(flattenedNames, forKey: .flattenedNames) }
        if isDiscriminator != nil { try container.encode(isDiscriminator, forKey: .isDiscriminator) }

        try super.encode(to: encoder)
    }
}
