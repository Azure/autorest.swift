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

public final class AutoRestReportClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version ""
        case v = ""

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v
        }
    }

    /// Options provided to configure this `AutoRestReportClient`.
    public let options: AutoRestReportClientOptions

    // MARK: Initializers

    /// Create a AutoRestReportClient client.
    /// - Parameters:
    ///   - baseUrl: Base URL for the AutoRestReportClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        baseUrl: URL,
        authPolicy: Authenticating,
        withOptions options: AutoRestReportClientOptions
    ) throws {
        self.options = options
        super.init(
            baseUrl: baseUrl,
            transport: URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: AutoRestReportClient.self, telemetryOptions: options.telemetryOptions),
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

    // MARK: AutoRestReportService

    /// Get test coverage report
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getReport(
        withOptions options: GetReportOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[String: Int]>
    ) {
        // Construct URL
        let urlTemplate = "/report"
        let pathParams = [
            "": ""
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        var queryParams: [QueryParameter] = [
            ("", "")
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        if let options = options {
            // Query options
            if let qualifier = options.qualifier {
                queryParams.append("qualifier", qualifier)
            }

            // Header options
        }
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
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            switch result {
            case let .success(data):
                guard let data = data else {
                    let noDataError = AzureError.sdk("Response data expected but not found.")
                    dispatchQueue.async {
                        completionHandler(.failure(noDataError), httpResponse)
                    }
                    return
                }
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.sdk("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode([String: Int].self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case let .failure(error):
                guard let data = httpResponse?.data else {
                    let noDataError = AzureError.sdk("Response data expected but not found.")
                    dispatchQueue.async {
                        completionHandler(.failure(noDataError), httpResponse)
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// Get optional test coverage report
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getOptionalReport(
        withOptions options: GetOptionalReportOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<[String: Int]>
    ) {
        // Construct URL
        let urlTemplate = "/report/optional"
        let pathParams = [
            "": ""
        ]
        guard let url = self.url(forTemplate: urlTemplate, withKwargs: pathParams) else {
            self.options.logger.error("Failed to construct url")
            return
        }
        // Construct query
        var queryParams: [QueryParameter] = [
            ("", "")
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        if let options = options {
            // Query options
            if let qualifier = options.qualifier {
                queryParams.append("qualifier", qualifier)
            }

            // Header options
        }
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
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            switch result {
            case let .success(data):
                guard let data = data else {
                    let noDataError = AzureError.sdk("Response data expected but not found.")
                    dispatchQueue.async {
                        completionHandler(.failure(noDataError), httpResponse)
                    }
                    return
                }
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.sdk("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode([String: Int].self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                        }
                    }
                }
            case let .failure(error):
                guard let data = httpResponse?.data else {
                    let noDataError = AzureError.sdk("Response data expected but not found.")
                    dispatchQueue.async {
                        completionHandler(.failure(noDataError), httpResponse)
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.sdk("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }
}
