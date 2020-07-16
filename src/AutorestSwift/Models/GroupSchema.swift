//
//  GroupSchema.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias GroupSchema = Compose3<GroupSchemaProperty, Schema, SchemaUsage>

public struct GroupSchemaProperty: Codable {
    public let properties: [GroupProperty]
}
