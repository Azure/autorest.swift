//
//  Discriminator.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public class Discriminator: Codable {
    public let property: Property

    public let immediate: [String: ComplexSchema]

    public let all: [String: ComplexSchema]
    
    enum CodingKeys: String, CodingKey {
    case property, immediate, all
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    property = try container.decode( Property.self, forKey: .property)
    immediate = try container.decode( [String: ComplexSchema].self, forKey: .immediate)
    all = try container.decode( [String: ComplexSchema].self, forKey: .all)
    }
     public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(property, forKey: .property)
    try container.encode(immediate, forKey: .immediate)
     try container.encode(all, forKey: .all)
    }
}
