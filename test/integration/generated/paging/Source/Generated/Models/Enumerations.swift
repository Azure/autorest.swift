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

/// The status of the request
public enum OperationResultStatus: RequestStringConvertible, Codable, Equatable {
    // Custom value for unrecognized enum values
    case custom(String)

    case succeeded

    case failed

    case canceled

    case accepted

    case creating

    case created

    case updating

    case updated

    case deleting

    case deleted

    case oK

    public var requestString: String {
        switch self {
        case let .custom(val):
            return val
        case .succeeded:
            return "Succeeded"
        case .failed:
            return "Failed"
        case .canceled:
            return "canceled"
        case .accepted:
            return "Accepted"
        case .creating:
            return "Creating"
        case .created:
            return "Created"
        case .updating:
            return "Updating"
        case .updated:
            return "Updated"
        case .deleting:
            return "Deleting"
        case .deleted:
            return "Deleted"
        case .oK:
            return "OK"
        }
    }

    public init(_ val: String) {
        switch val.lowercased() {
        case "succeeded":
            self = .succeeded
        case "failed":
            self = .failed
        case "canceled":
            self = .canceled
        case "accepted":
            self = .accepted
        case "creating":
            self = .creating
        case "created":
            self = .created
        case "updating":
            self = .updating
        case "updated":
            self = .updated
        case "deleting":
            self = .deleting
        case "deleted":
            self = .deleted
        case "ok":
            self = .oK
        default:
            self = .custom(val)
        }
    }

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        self.init(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(requestString)
    }
}
