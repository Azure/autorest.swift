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

public final class Paths {
    public let client: AutoRestParameterizedHostTestClient

    public let commonOptions: AzureClientOptions

    /// Options provided to configure this `AutoRestParameterizedHostTestClient`.
    public let options: AutoRestParameterizedHostTestClientOptions

    init(client: AutoRestParameterizedHostTestClient) {
        self.client = client
        self.options = client.options
        self.commonOptions = client.commonOptions
    }

    public func url(
        forTemplate templateIn: String,
        withKwargs kwargs: [String: String]? = nil,
        and addedParams: [QueryParameter]? = nil
    ) -> URL? {
        return client.url(forTemplate: templateIn, withKwargs: kwargs, and: addedParams)
    }

    public func request(
        _ request: HTTPRequest,
        context: PipelineContext?,
        completionHandler: @escaping HTTPResultHandler<Data?>
    ) {
        return client.request(request, context: context, completionHandler: completionHandler)
    }

    /// Get a 200 to test a valid base uri
    /// - Parameters:
    ///    - accountName : Account Name
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getEmpty(
        accountName _: String,
        withOptions options: GetEmptyOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate = "/customuri"
        let pathParams = [
            "": ""
        ]
        // Construct query
        let queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Construct request
        guard let requestUrl = url(forTemplate: urlTemplate, withKwargs: pathParams, and: queryParams) else {
            self.options.logger.error("Failed to construct url")
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
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.sdk("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

            switch result {
            case .success:
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
                    dispatchQueue.async {
                        completionHandler(
                            .success(()),
                            httpResponse
                        )
                    }
                }
            case .failure:
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
