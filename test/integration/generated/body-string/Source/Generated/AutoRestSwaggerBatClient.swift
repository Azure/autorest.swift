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

public final class AutoRestSwaggerBatClient: PipelineClient {
    /// Options provided to configure this `AutoRestSwaggerBatClient`.
    public let options: AutoRestSwaggerBatClientOptions

    // MARK: Initializers

    /// Create a AutoRestSwaggerBatClient client.
    /// - Parameters:
    ///   - endpoint: Base URL for the AutoRestSwaggerBatClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        url: URL? = nil,
        authPolicy: Authenticating,
        withOptions options: AutoRestSwaggerBatClientOptions
    ) throws {
        let defaultHost = URL(string: "http://localhost:3000")
        guard let endpoint = url ?? defaultHost else {
            fatalError("Unable to determine base URL. ")
        }
        self.options = options
        super.init(
            endpoint: endpoint,
            transport: options.transportOptions.transport ?? URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestSwaggerBatClient.self, telemetryOptions: options.telemetryOptions),
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

    public lazy var enumOperation = EnumOperation(client: self)
    public lazy var stringOperation = StringOperation(client: self)

    // MARK: Client Methods
}
