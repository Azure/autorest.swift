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

public final class Datetimerfc1123 {
    public let client: AutoRestRfC1123DateTimeTestClient

    init(client: AutoRestRfC1123DateTimeTestClient) {
        self.client = client
    }

    /// Get null datetime value
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getNull(
        withOptions options: GetNullOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date?>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/null"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    if data.count == 0 {
                        dispatchQueue.async {
                            completionHandler(.success(nil), httpResponse)
                        }
                        return
                    }

                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Get invalid datetime value
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getInvalid(
        withOptions options: GetInvalidOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/invalid"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Get overflow datetime value
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getOverflow(
        withOptions options: GetOverflowOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/overflow"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Get underflow datetime value
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getUnderflow(
        withOptions options: GetUnderflowOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/underflow"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Put max datetime value Fri, 31 Dec 9999 23:59:59 GMT
    /// - Parameters:
    ///    - utcMaxDateTime : datetime body
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func put(
        utcMaxDateTime: Rfc1123Date,
        withOptions options: PutUtcMaxDateTimeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Content-Type", "application/json", .encode),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        guard let requestBody = try? JSONEncoder().encode(utcMaxDateTime) else {
            client.options.logger.error("Failed to encode request body as json.")
            return
        }
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .put, url: requestUrl, headers: params.headers, data: requestBody)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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

    /// Get max datetime value fri, 31 dec 9999 23:59:59 gmt
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getUtcLowercaseMaxDateTime(
        withOptions options: GetUtcLowercaseMaxDateTimeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/max/lowercase"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Get max datetime value FRI, 31 DEC 9999 23:59:59 GMT
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getUtcUppercaseMaxDateTime(
        withOptions options: GetUtcUppercaseMaxDateTimeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/max/uppercase"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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

    /// Put min datetime value Mon, 1 Jan 0001 00:00:00 GMT
    /// - Parameters:
    ///    - utcMinDateTime : datetime body
    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func put(
        utcMinDateTime: Rfc1123Date,
        withOptions options: PutUtcMinDateTimeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Void>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Content-Type", "application/json", .encode),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        guard let requestBody = try? JSONEncoder().encode(utcMinDateTime) else {
            client.options.logger.error("Failed to encode request body as json.")
            return
        }
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .put, url: requestUrl, headers: params.headers, data: requestBody)
        else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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

    /// Get min datetime value Mon, 1 Jan 0001 00:00:00 GMT
    /// - Parameters:

    ///    - options: A list of options for the operation
    ///    - completionHandler: A completion handler that receives a status code on
    ///     success.
    public func getUtcMinDateTime(
        withOptions options: GetUtcMinDateTimeOptions? = nil,
        completionHandler: @escaping HTTPResultHandler<Rfc1123Date>
    ) {
        // Create request parameters
        let params = RequestParameters(
            (.uri, "$host", client.endpoint.absoluteString, .skipEncoding),
            (.header, "Accept", "application/json", .encode)
        )

        // Construct request
        let urlTemplate = "/datetimerfc1123/min"
        guard let requestUrl = client.url(host: "{$host}", template: urlTemplate, params: params),
            let request = try? HTTPRequest(method: .get, url: requestUrl, headers: params.headers) else {
            client.options.logger.error("Failed to construct HTTP request.")
            return
        }
        // Send request
        let context = PipelineContext.of(keyValues: [
            ContextKey.allowedStatusCodes.rawValue: [200] as AnyObject
        ])
        context.add(cancellationToken: options?.cancellationToken, applying: client.options)
        context.merge(with: options?.context)
        client.request(request, context: context) { result, httpResponse in
            let dispatchQueue = options?.dispatchQueue ?? self.client.commonOptions.dispatchQueue ?? DispatchQueue.main
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
                    do {
                        let decoder = JSONDecoder()
                        let decoded = try decoder.decode(Rfc1123Date.self, from: data)
                        dispatchQueue.async {
                            completionHandler(.success(decoded), httpResponse)
                        }
                    } catch {
                        dispatchQueue.async {
                            completionHandler(.failure(AzureError.client("Decoding error.", error)), httpResponse)
                        }
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
