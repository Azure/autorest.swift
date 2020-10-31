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

public final class PathItems {
    public let client: AutoRestUrlTestClient

    public let commonOptions: ClientOptions

    /// Options provided to configure this `AutoRestUrlTestClient`.
    public let options: AutoRestUrlTestClientOptions

    init(client: AutoRestUrlTestClient) {
        self.client = client
        self.options = client.options
        self.commonOptions = client.commonOptions
    }

    public func url(
        host hostIn: String? = nil,
        template templateIn: String,
        pathParams pathParamsIn: [String: String]? = nil,
        queryParams queryParamsIn: [QueryParameter]? = nil
    ) -> URL? {
        return client.url(host: hostIn, template: templateIn, pathParams: pathParamsIn, queryParams: queryParamsIn)
    }

    public func request(
        _ request: HTTPRequest,
        context: PipelineContext?,
        completionHandler: @escaping HTTPResultHandler<Data?>
    ) {
        return client.request(request, context: context, completionHandler: completionHandler)
    }

    /// send globalStringPath='globalStringPath', pathItemStringPath='pathItemStringPath', localStringPath='localStringPath', globalStringQuery='globalStringQuery', pathItemStringQuery='pathItemStringQuery', localStringQuery='localStringQuery'
    /// - Parameters:
    ///    - pathItemStringPath : A string value 'pathItemStringPath' that appears in the path
    ///    - localStringPath : should contain value 'localStringPath'
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func listAllWithValues(
        pathItemStringPath: String,
        localStringPath: String,
        withOptions options: GetAllWithValuesOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate =
            "/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/pathItemStringQuery/localStringQuery"
        let pathParams = [
            "pathItemStringPath": pathItemStringPath,
            "localStringPath": localStringPath,
            "$host": client.endpoint.absoluteString,
            "globalStringPath": client.globalStringPath
        ]
        // Construct query
        var queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        // Query options
        if let pathItemStringQuery = options?.pathItemStringQuery {
            queryParams.append("pathItemStringQuery", pathItemStringQuery)
        }
        if let localStringQuery = options?.localStringQuery {
            queryParams.append("localStringQuery", localStringQuery)
        }
        if let globalStringQuery = client.globalStringQuery {
            queryParams.append("globalStringQuery", globalStringQuery)
        }
        // Header options
        // Construct request
        guard let requestUrl = url(
            host: "{$host}",
            template: urlTemplate,
            pathParams: pathParams,
            queryParams: queryParams
        ) else {
            self.options.logger.error("Failed to construct request url")
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
        context.merge(with: options?.context)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

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
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// send globalStringPath='globalStringPath', pathItemStringPath='pathItemStringPath', localStringPath='localStringPath', globalStringQuery=null, pathItemStringQuery='pathItemStringQuery', localStringQuery='localStringQuery'
    /// - Parameters:
    ///    - pathItemStringPath : A string value 'pathItemStringPath' that appears in the path
    ///    - localStringPath : should contain value 'localStringPath'
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getGlobalQueryNull(
        pathItemStringPath: String,
        localStringPath: String,
        withOptions options: GetGlobalQueryNullOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate =
            "/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/localStringQuery"
        let pathParams = [
            "pathItemStringPath": pathItemStringPath,
            "localStringPath": localStringPath,
            "$host": client.endpoint.absoluteString,
            "globalStringPath": client.globalStringPath
        ]
        // Construct query
        var queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        // Query options
        if let pathItemStringQuery = options?.pathItemStringQuery {
            queryParams.append("pathItemStringQuery", pathItemStringQuery)
        }
        if let localStringQuery = options?.localStringQuery {
            queryParams.append("localStringQuery", localStringQuery)
        }
        if let globalStringQuery = client.globalStringQuery {
            queryParams.append("globalStringQuery", globalStringQuery)
        }
        // Header options
        // Construct request
        guard let requestUrl = url(
            host: "{$host}",
            template: urlTemplate,
            pathParams: pathParams,
            queryParams: queryParams
        ) else {
            self.options.logger.error("Failed to construct request url")
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
        context.merge(with: options?.context)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

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
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// send globalStringPath=globalStringPath, pathItemStringPath='pathItemStringPath', localStringPath='localStringPath', globalStringQuery=null, pathItemStringQuery='pathItemStringQuery', localStringQuery=null
    /// - Parameters:
    ///    - pathItemStringPath : A string value 'pathItemStringPath' that appears in the path
    ///    - localStringPath : should contain value 'localStringPath'
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getGlobalAndLocalQueryNull(
        pathItemStringPath: String,
        localStringPath: String,
        withOptions options: GetGlobalAndLocalQueryNullOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate =
            "/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/null/pathItemStringQuery/null"
        let pathParams = [
            "pathItemStringPath": pathItemStringPath,
            "localStringPath": localStringPath,
            "$host": client.endpoint.absoluteString,
            "globalStringPath": client.globalStringPath
        ]
        // Construct query
        var queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        // Query options
        if let pathItemStringQuery = options?.pathItemStringQuery {
            queryParams.append("pathItemStringQuery", pathItemStringQuery)
        }
        if let localStringQuery = options?.localStringQuery {
            queryParams.append("localStringQuery", localStringQuery)
        }
        if let globalStringQuery = client.globalStringQuery {
            queryParams.append("globalStringQuery", globalStringQuery)
        }
        // Header options
        // Construct request
        guard let requestUrl = url(
            host: "{$host}",
            template: urlTemplate,
            pathParams: pathParams,
            queryParams: queryParams
        ) else {
            self.options.logger.error("Failed to construct request url")
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
        context.merge(with: options?.context)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

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
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }

    /// send globalStringPath='globalStringPath', pathItemStringPath='pathItemStringPath', localStringPath='localStringPath', globalStringQuery='globalStringQuery', pathItemStringQuery=null, localStringQuery=null
    /// - Parameters:
    ///    - pathItemStringPath : A string value 'pathItemStringPath' that appears in the path
    ///    - localStringPath : should contain value 'localStringPath'
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getLocalPathItemQueryNull(
        pathItemStringPath: String,
        localStringPath: String,
        withOptions options: GetLocalPathItemQueryNullOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Construct URL
        let urlTemplate =
            "/pathitem/nullable/globalStringPath/{globalStringPath}/pathItemStringPath/{pathItemStringPath}/localStringPath/{localStringPath}/globalStringQuery/null/null"
        let pathParams = [
            "pathItemStringPath": pathItemStringPath,
            "localStringPath": localStringPath,
            "$host": client.endpoint.absoluteString,
            "globalStringPath": client.globalStringPath
        ]
        // Construct query
        var queryParams: [QueryParameter] = [
        ]

        // Construct headers
        var headers = HTTPHeaders()
        headers["Accept"] = "application/json"
        // Process endpoint options
        // Query options
        if let pathItemStringQuery = options?.pathItemStringQuery {
            queryParams.append("pathItemStringQuery", pathItemStringQuery)
        }
        if let localStringQuery = options?.localStringQuery {
            queryParams.append("localStringQuery", localStringQuery)
        }
        if let globalStringQuery = client.globalStringQuery {
            queryParams.append("globalStringQuery", globalStringQuery)
        }
        // Header options
        // Construct request
        guard let requestUrl = url(
            host: "{$host}",
            template: urlTemplate,
            pathParams: pathParams,
            queryParams: queryParams
        ) else {
            self.options.logger.error("Failed to construct request url")
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
        context.merge(with: options?.context)
        self.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.commonOptions.dispatchQueue ?? DispatchQueue.main
            guard let data = httpResponse?.data else {
                let noDataError = AzureError.client("Response data expected but not found.")
                dispatchQueue.async {
                    completionHandler(.failure(noDataError), httpResponse)
                }
                return
            }

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
            case .failure:
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ErrorType.self, from: data)
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.service("", decoded)), httpResponse)
                    }
                } catch {
                    dispatchQueue.async {
                        completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                    }
                }
            }
        }
    }
}
