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

public final class AutoRestHeadTestClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version ""
        case v = ""

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v
        }
    }

    /// Options provided to configure this `AutoRestHeadTestClient`.
    public let options: AutoRestHeadTestClientOptions

    // MARK: Initializers

    /// Create a AutoRestHeadTestClient client.
    /// - Parameters:
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public convenience init(
        authPolicy: Authenticating,
        withOptions options: AutoRestHeadTestClientOptions
    ) throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        try self.init(
            baseUrl: baseUrl,
            authPolicy: authPolicy,
            withOptions: options
        )
    }

    /// Create a AutoRestHeadTestClient client.
    /// - Parameters:
    ///   - baseUrl: Base URL for the AutoRestHeadTestClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        baseUrl: URL,
        authPolicy: Authenticating,
        withOptions options: AutoRestHeadTestClientOptions
    ) throws {
        self.options = options
        super.init(
            baseUrl: baseUrl,
            transport: URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestHeadTestClient.self, telemetryOptions: options.telemetryOptions),
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

    public lazy var httpsuccess: HttpSuccess = HttpSuccess(client: self)

    // MARK: Public Client Methods
}
