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

public final class AutoRestSwaggerBatFormDataClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version ""
        case v = ""

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v
        }
    }

    /// Options provided to configure this `AutoRestSwaggerBatFormDataClient`.
    public let options: AutoRestSwaggerBatFormDataClientOptions

    // MARK: Initializers

    /// Create a AutoRestSwaggerBatFormDataClient client.
    /// - Parameters:
    ///   - baseUrl: Base URL for the AutoRestSwaggerBatFormDataClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        url: URL? = nil,
        authPolicy: Authenticating,
        withOptions options: AutoRestSwaggerBatFormDataClientOptions
    ) throws {
        let defaultHost = URL(string: "")
        guard let baseUrl = url ?? defaultHost else {
            fatalError("Unable to determine base URL. ")
        }
        self.options = options
        super.init(
            baseUrl: baseUrl,
            transport: URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestSwaggerBatFormDataClient.self, telemetryOptions: options.telemetryOptions),
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

    public lazy var autorestswaggerbatformdataservice: AutoRestSwaggerBATFormDataService =
        AutoRestSwaggerBATFormDataService(client: self)

    // MARK: Public Client Methods
}
