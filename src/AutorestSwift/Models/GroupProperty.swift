//
//  GroupProperty.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public class GroupProperty: Property {
    public let originalParameter: [Parameter]

    enum CodingKeys: String, CodingKey {
        case originalParameter
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        originalParameter = try container.decode([Parameter].self, forKey: .originalParameter)
        try super.init(from: decoder)
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(originalParameter, forKey: .originalParameter)
        try super.encode(to: encoder)
    }
}
