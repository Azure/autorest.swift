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

public enum FlattenedProductPropertiesProvisioningStateValues: String, Codable, RequestStringConvertible {
    case succeeded = "Succeeded"

    case failed = "Failed"

    case canceled = "canceled"

    case accepted = "Accepted"

    case creating = "Creating"

    case created = "Created"

    case updating = "Updating"

    case updated = "Updated"

    case deleting = "Deleting"

    case deleted = "Deleted"

    case oK = "OK"

    public var requestString: String {
        return rawValue
    }
}
