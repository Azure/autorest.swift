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

public final class HttpSuccess {
    public let client: AutoRestHeadTestClient

    public let commonOptions: ClientOptions

    /// Options provided to configure this `AutoRestHeadTestClient`.
    public let options: AutoRestHeadTestClientOptions

    init(client: AutoRestHeadTestClient) {
        self.client = client
        self.options = client.options
        self.commonOptions = client.commonOptions
    }

    public func url(
        host hostIn: String? = nil,
        template templateIn: String,
        withKwargs kwargs: [String: String]? = nil,
        and addedParams: [QueryParameter]? = nil
    ) -> URL? {
        return client.url(host: hostIn, template: templateIn, withKwargs: kwargs, and: addedParams)
    }

    public func request(
        _ request: HTTPRequest,
        context: PipelineContext?,
        completionHandler: @escaping HTTPResultHandler<Data?>
    ) {
        return client.request(request, context: context, completionHandler: completionHandler)
    }

    /// Return 200 status code if successful
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func head200(
        withOptions options: Head200Options? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/http/success/200"
        let pathParams = [
            "$host": client.baseUrl.absoluteString
        ]
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        let headers = HTTPHeaders()
        // Construct request
        guard let requestUrl = url(host: "{$host}", template: urlTemplate, withKwargs: pathParams, and: queryParams)
        else {
            self.options.logger.error("Failed to construct request url")
            return
        }

        guard let request = try? HTTPRequest(method: .head, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200, 404] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main

            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    200
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
                if [
                    404
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
            case let .failure(error):
                dispatchQueue.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }

    /// Return 204 status code if successful
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func head204(
        withOptions options: Head204Options? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/http/success/204"
        let pathParams = [
            "$host": client.baseUrl.absoluteString
        ]
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        let headers = HTTPHeaders()
        // Construct request
        guard let requestUrl = url(host: "{$host}", template: urlTemplate, withKwargs: pathParams, and: queryParams)
        else {
            self.options.logger.error("Failed to construct request url")
            return
        }

        guard let request = try? HTTPRequest(method: .head, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [204, 404] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main

            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    204
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
                if [
                    404
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
            case let .failure(error):
                dispatchQueue.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }

    /// Return 404 status code if successful
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func head404(
        withOptions options: Head404Options? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/http/success/404"
        let pathParams = [
            "$host": client.baseUrl.absoluteString
        ]
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        let headers = HTTPHeaders()
        // Construct request
        guard let requestUrl = url(host: "{$host}", template: urlTemplate, withKwargs: pathParams, and: queryParams)
        else {
            self.options.logger.error("Failed to construct request url")
            return
        }

        guard let request = try? HTTPRequest(method: .head, url: requestUrl, headers: headers) else {
            self.options.logger.error("Failed to construct Http request")
            return
        }

        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [204, 404] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: self.options)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main

            switch result {
            case .success:
                guard let statusCode = httpResponse?.statusCode else {
                    let noStatusCodeError = AzureError.client("Expected a status code in response but didn't find one.")
                    dispatchQueue.async {
                        completionHandler(.failure(noStatusCodeError), httpResponse)
                    }
                    return
                }
                if [
                    204
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
                if [
                    404
                ].contains(statusCode) {
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
            case let .failure(error):
                dispatchQueue.async {
                    completionHandler(.failure(error), httpResponse)
                }
            }
        }
    }
}
