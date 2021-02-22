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

public struct Product: Codable {
    // MARK: Properties

    public let integer: Int32?

    public let string: String?

    // MARK: Initializers

    /// Initialize a `Product` structure.
    /// - Parameters:
    ///   - integer:
    ///   - string:
    public init(
        integer: Int32? = nil, string: String? = nil
    ) {
        self.integer = integer
        self.string = string
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case integer = "integer"
        case string = "string"
    }

    /// Initialize a `Product` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.integer = try? container.decode(Int32.self, forKey: .integer)
        self.string = try? container.decode(String.self, forKey: .string)
    }

    /// Encode a `Product` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if integer != nil { try? container.encode(integer, forKey: .integer) }
        if string != nil { try? container.encode(string, forKey: .string) }
    }
}
