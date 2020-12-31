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

public struct ErrorType: Codable, Swift.Error {
    // MARK: Properties

    public let code: Int32?

    public let message: String?

    public let fields: String?

    // MARK: Initializers

    /// Initialize a `ErrorType` structure.
    /// - Parameters:
    ///   - code:
    ///   - message:
    ///   - fields:
    public init(
        code: Int32? = nil, message: String? = nil, fields: String? = nil
    ) {
        self.code = code
        self.message = message
        self.fields = fields
    }

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
        case fields = "fields"
    }

    /// Initialize a `ErrorType` structure from decoder
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try? container.decode(Int32.self, forKey: .code)
        self.message = try? container.decode(String.self, forKey: .message)
        self.fields = try? container.decode(String.self, forKey: .fields)
    }

    /// Encode a `ErrorType` structure
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if code != nil { try? container.encode(code, forKey: .code) }
        if message != nil { try? container.encode(message, forKey: .message) }
        if fields != nil { try? container.encode(fields, forKey: .fields) }
    }
}