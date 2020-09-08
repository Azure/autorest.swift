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

public final class AutoRestSwaggerBatFileClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version ""
        case v = ""

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v
        }
    }

    /// Options provided to configure this `AutoRestSwaggerBatFileClient`.
    public let options: AutoRestSwaggerBatFileClientOptions

    // MARK: Initializers

    /// Create a AutoRestSwaggerBatFileClient client.
    /// - Parameters:
    ///   - baseUrl: Base URL for the AutoRestSwaggerBatFileClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        baseUrl: URL,
        authPolicy: Authenticating,
        withOptions options: AutoRestSwaggerBatFileClientOptions
    ) throws {
        self.options = options
        super.init(
            baseUrl: baseUrl,
            transport: URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestSwaggerBatFileClient.self, telemetryOptions: options.telemetryOptions),
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

    // MARK: Public Client Methods

    // MARK: files

    /// Get file
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getFile(
        withOptions options: GetFileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/files/stream/nonempty"
        let pathParams = [
            "": ""
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        let queryParams: [QueryParameter] = [
            ("", "")
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "image/png, application/json"
        // Construct request
        guard let requestUrl = url.appendingQueryParameters(queryParams) else {
            self.options.logger.error("Failed to append query parameters to url")
            return
        }

        guard let request = try? HTTPRequest(method: .get, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(.success(()), httpResponse)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }

    /// Get a large file
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getFileLarge(
        withOptions options: GetFileLargeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/files/stream/verylarge"
        let pathParams = [
            "": ""
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        let queryParams: [QueryParameter] = [
            ("", "")
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "image/png, application/json"
        // Construct request
        guard let requestUrl = url.appendingQueryParameters(queryParams) else {
            self.options.logger.error("Failed to append query parameters to url")
            return
        }

        guard let request = try? HTTPRequest(method: .get, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(.success(()), httpResponse)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }

    /// Get empty file
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getEmptyFile(
        withOptions options: GetEmptyFileOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/files/stream/empty"
        let pathParams = [
            "": ""
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        let queryParams: [QueryParameter] = [
            ("", "")
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "image/png, application/json"
        // Construct request
        guard let requestUrl = url.appendingQueryParameters(queryParams) else {
            self.options.logger.error("Failed to append query parameters to url")
            return
        }

        guard let request = try? HTTPRequest(method: .get, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    completionHandler(.success(()), httpResponse)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }
}