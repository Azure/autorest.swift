// --------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for
// license information.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is
// regenerated.
// --------------------------------------------------------------------------

import AzureCore
import Foundation
// swiftlint:disable superfluous_disable_command
// swiftlint:disable identifier_name
// swiftlint:disable line_length
// swiftlint:disable cyclomatic_complexity

public struct Pet: Codable {
    // MARK: Properties

    /// name
    public let name: String?
    /// Type of Pet
    public let daysOfWeek: DaysOfWeekExtensibleEnum?

    public let intEnum: IntEnum

    // MARK: Initializers

    /// Initialize a `Pet` structure.
    /// - Parameters:
    ///   - name: name
    ///   - daysOfWeek: Type of Pet
    ///   - intEnum:
    public init(
        name: String? = nil, daysOfWeek: DaysOfWeekExtensibleEnum? = nil, intEnum: IntEnum
    ) {
        self.name = name
        self.daysOfWeek = daysOfWeek
        self.intEnum = intEnum
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case name
        case daysOfWeek
        case intEnum
    }

    /// Initialize a `Pet` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decode(String.self, forKey: .name)
        self.daysOfWeek = try? container.decode(DaysOfWeekExtensibleEnum.self, forKey: .daysOfWeek)
        self.intEnum = try container.decode(IntEnum.self, forKey: .intEnum)
    }

    /// Encode a `Pet` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if name != nil { try? container.encode(name, forKey: .name) }
        if daysOfWeek != nil { try? container.encode(daysOfWeek, forKey: .daysOfWeek) }
        try container.encode(intEnum, forKey: .intEnum)
    }
}
