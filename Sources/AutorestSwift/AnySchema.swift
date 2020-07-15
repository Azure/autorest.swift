//
//  AnySchema.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

/// a schema types that are any types
public struct AnySchema: CodeModelProperty {
    public let properties = [String: String]()

    public let defaultProperties = [String]()

    public let additionalProperties = false

    public let allOf: [Schema]
}
