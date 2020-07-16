//
//  Relations.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public struct Relations: Codable {
    public let immediate: [ComplexSchema]

    public let all: [ComplexSchema]
}
