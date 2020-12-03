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

public struct PetAction: Codable {
    // MARK: Properties

    /// action feedback
    public let actionResponse: String?

    // MARK: Initializers

    /// Initialize a `PetAction` structure.
    /// - Parameters:
    ///   - actionResponse: action feedback
    public init(
        actionResponse: String? = nil
    ) {
        self.actionResponse = actionResponse
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case actionResponse
    }

    /// Initialize a `PetAction` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.actionResponse = try? container.decode(String.self, forKey: .actionResponse)
    }

    /// Encode a `PetAction` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if actionResponse != nil { try? container.encode(actionResponse, forKey: .actionResponse) }
    }
}
