//
//  Property.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// a property is a child value in an object
public struct Property: Codable {
    // if the property is marked read-only (ie, not intended to be sent to the service)
    public let readOnly: Bool?

    // the wire name of this property
    public let serializedName: String

    // when a property is flattened, the property will be the set of serialized names to get to that target property.\n\nIf flattenedName is present, then this property is a flattened property.\n\n(ie, ['properties','name'] )
    public let flattenedNames: [String]?

    // if this property is used as a discriminator for a polymorphic type
    public let isDiscriminator: Bool?

    // TODO: Apply allOf
    // public let allOf: [Value]
}
