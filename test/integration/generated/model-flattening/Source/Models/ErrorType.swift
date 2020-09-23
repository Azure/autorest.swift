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

public final class ErrorType: Codable, Swift.Error {
    public let status: Int32?

    public let message: String?

    public let parentError: ErrorType?

    /// Initialize a `ErrorType` structure.
    /// - Parameters:
    ///   - status:
    ///   - message:
    ///   - parentError:
    public init(
        status: Int32? = nil, message: String? = nil, parentError: ErrorType? = nil
    ) {
        self.status = status
        self.message = message
        self.parentError = parentError
    }

    enum CodingKeys: String, CodingKey {
        case status
        case message
        case parentError
    }

    /// Initialize a `ErrorType` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try? container.decode(Int32.self, forKey: .status)
        self.message = try? container.decode(String.self, forKey: .message)
        self.parentError = try? container.decode(ErrorType.self, forKey: .parentError)
    }

    /// Encode a `ErrorType` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if status != nil { try? container.encode(status, forKey: .status) }
        if message != nil { try? container.encode(message, forKey: .message) }
        if parentError != nil { try? container.encode(parentError, forKey: .parentError) }
    }
}