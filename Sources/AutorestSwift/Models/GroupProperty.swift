//
//  GroupProperty.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

public typealias GroupProperty = Compose<GroupPropertyBundle, Property>

public struct GroupPropertyBundle: Codable {
    public let originalParameter: [Parameter]

}
