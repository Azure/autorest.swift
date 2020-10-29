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

/// User-configurable options for the `AutoRestRfC1123DateTimeTestClient`.
public struct AutoRestRfC1123DateTimeTestClientOptions: ClientOptions {
    /// The API version of the  to invoke.
    public let apiVersion: String
    /// The `ClientLogger` to be used by this `AutoRestRfC1123DateTimeTestClient`.
    public let logger: ClientLogger
    /// Options for configuring telemetry sent by this `AutoRestRfC1123DateTimeTestClient`.
    public let telemetryOptions: TelemetryOptions
    /// Global transport options
    public let transportOptions: TransportOptions
    /// The default dispatch queue on which to call all completion handler. Defaults to `DispatchQueue.main`.
    public let dispatchQueue: DispatchQueue?

    /// Initialize a `AutoRestRfC1123DateTimeTestClientOptions` structure.
    /// - Parameters:
    ///   - apiVersion: The API version of the  to invoke.
    ///   - logger: The `ClientLogger` to be used by this `AutoRestRfC1123DateTimeTestClient`.
    ///   - telemetryOptions: Options for configuring telemetry sent by this `AutoRestRfC1123DateTimeTestClient`.
    ///   - cancellationToken: A token used to make a best-effort attempt at canceling a request.
    ///   - dispatchQueue: The default dispatch queue on which to call all completion handler. Defaults to `DispatchQueue.main`.
    public init(
        apiVersion: AutoRestRfC1123DateTimeTestClient.ApiVersion = .latest,
        logger: ClientLogger = ClientLoggers.default(tag: "AutoRestRfC1123DateTimeTestClientClient"),
        telemetryOptions: TelemetryOptions = TelemetryOptions(),
        transportOptions: TransportOptions? = nil,
        dispatchQueue: DispatchQueue? = nil
    ) {
        self.apiVersion = apiVersion.rawValue
        self.logger = logger
        self.telemetryOptions = telemetryOptions
        self.transportOptions = transportOptions ?? TransportOptions()
        self.dispatchQueue = dispatchQueue
    }
}
