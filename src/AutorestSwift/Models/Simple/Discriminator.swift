//
//  Discriminator.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct Discriminator: Codable {
    public var property: PropertyProtocol

    public var immediate: [String: ComplexSchemaProtocol]

    public var all: [String: ComplexSchemaProtocol]
}
