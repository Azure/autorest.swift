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

public struct Resource: Codable, Equatable {
    // MARK: Properties

    /// Resource Id
    public let id: String?
    /// Resource Type
    public let type: String?
    /// Dictionary of <string>
    public let tags: [String: String?]?
    /// Resource Location
    public let location: String?
    /// Resource Name
    public let name: String?

    // MARK: Initializers

    /// Initialize a `Resource` structure.
    /// - Parameters:
    ///   - id: Resource Id
    ///   - type: Resource Type
    ///   - tags: Dictionary of <string>
    ///   - location: Resource Location
    ///   - name: Resource Name
    public init(
        id: String? = nil, type: String? = nil, tags: [String: String?]? = nil, location: String? = nil,
        name: String? = nil
    ) {
        self.id = id
        self.type = type
        self.tags = tags
        self.location = location
        self.name = name
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case type = "type"
        case tags = "tags"
        case location = "location"
        case name = "name"
    }

    /// Initialize a `Resource` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try? container.decode(String.self, forKey: .id)
        self.type = try? container.decode(String.self, forKey: .type)
        self.tags = try? container.decode([String: String?].self, forKey: .tags)
        self.location = try? container.decode(String.self, forKey: .location)
        self.name = try? container.decode(String.self, forKey: .name)
    }

    /// Encode a `Resource` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if id != nil { try? container.encode(id, forKey: .id) }
        if type != nil { try? container.encode(type, forKey: .type) }
        if tags != nil { try? container.encode(tags, forKey: .tags) }
        if location != nil { try? container.encode(location, forKey: .location) }
        if name != nil { try? container.encode(name, forKey: .name) }
    }
}
