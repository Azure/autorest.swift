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
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

public final class AutoRestValidationTestClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version "1.0.0"
        case v100 = "1.0.0"

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v100
        }
    }

    /// Options provided to configure this `AutoRestValidationTestClient`.
    public let options: AutoRestValidationTestClientOptions

    // MARK: Initializers

    /// Create a AutoRestValidationTestClient client.
    /// - Parameters:
    ///   - endpoint: Base URL for the AutoRestValidationTestClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        subscriptionId: String,
        url: URL? = nil,
        authPolicy: Authenticating,
        withOptions options: AutoRestValidationTestClientOptions
    ) throws {
        let defaultHost = URL(string: "http://localhost:3000")
        guard let endpoint = url ?? defaultHost else {
            fatalError("Unable to determine base URL. ")
        }
        self.subscriptionId = subscriptionId
        self.options = options
        super.init(
            endpoint: endpoint,
            transport: options.transportOptions.transport ?? URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestValidationTestClient.self, telemetryOptions: options.telemetryOptions),
                RequestIdPolicy(),
                AddDatePolicy(),
                authPolicy,
                ContentDecodePolicy(),
                LoggingPolicy(),
                NormalizeETagPolicy()
            ],
            logger: options.logger,
            options: options
        )
    }

    // /// Subscription ID.
    public var subscriptionId: String

    public lazy var autoRestValidationTest = AutoRestValidationTest(client: self)

    // MARK: Public Client Methods
}
