//
//  Property.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// a property is a child value in an object
public protocol PropertyProtocol: ValueProtocol {

    // if the property is marked read-only (ie, not intended to be sent to the service)
    var readOnly: Bool? { get set }

    // the wire name of this property
    var serializedName: String { get set }

    // when a property is flattened, the property will be the set of serialized names to get to that target property.\n\nIf flattenedName is present, then this property is a flattened property.\n\n(ie, ['properties','name'] )
    var flattenedNames: [String]? { get set }

    // if this property is used as a discriminator for a polymorphic type
    var isDiscriminator: Bool? { get set }
}
