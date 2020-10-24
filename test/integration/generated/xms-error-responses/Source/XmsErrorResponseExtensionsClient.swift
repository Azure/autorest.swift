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

extension CharacterSet {
    static let urlQueryValueAllowed4 = urlQueryAllowed.subtracting(.init(charactersIn: "!*'();:@&=+$,/?"))
    static let urlPathAllowed4 = urlPathAllowed.subtracting(.init(charactersIn: "!*'()@&=+$,/:"))
}

public final class XmsErrorResponseExtensionsClient: PipelineClient {
    /// API version of the  to invoke. Defaults to the latest.
    public enum ApiVersion: String {
        /// API version ""
        case v = ""

        /// The most recent API version of the
        public static var latest: ApiVersion {
            return .v
        }
    }

    /// Options provided to configure this `XmsErrorResponseExtensionsClient`.
    public let options: XmsErrorResponseExtensionsClientOptions

    // MARK: Initializers

    /// Create a XmsErrorResponseExtensionsClient client.
    /// - Parameters:
    ///   - baseUrl: Base URL for the XmsErrorResponseExtensionsClient.
    ///   - authPolicy: An `Authenticating` policy to use for authenticating client requests.
    ///   - options: Options used to configure the client.
    public init(
        url: URL? = nil,
        authPolicy: Authenticating,
        withOptions options: XmsErrorResponseExtensionsClientOptions
    ) throws {
        let defaultHost = URL(string: "http://localhost")
        guard let baseUrl = url ?? defaultHost else {
            fatalError("Unable to determine base URL. ")
        }
        self.options = options
        super.init(
            baseUrl: baseUrl,
            transport: URLSessionTransport(),
            policies: [
                UserAgentPolicy(for: XmsErrorResponseExtensionsClient.self, telemetryOptions: options.telemetryOptions),
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

    public func url(
        forTemplate templateIn: String,
        withKwargs kwargs: [String: String]? = nil,
        and addedParams: [QueryParameter]? = nil
    ) -> URL? {
        var template = templateIn
        if template.hasPrefix("/") { template = String(template.dropFirst()) }

        if let urlKwargs = kwargs {
            for (key, value) in urlKwargs {
                if let encodedPathValue = value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed4) {
                    template = template.replacingOccurrences(of: "{\(key)}", with: encodedPathValue)
                }
            }
        }

        var urlString = baseUrl.absoluteString

        // if template.starts(with: urlString) {
        //    urlString = template
        // } else {
        urlString += template
        // }
        guard let url = URL(string: urlString) else {
            return nil
        }

        guard !(addedParams?.isEmpty ?? false) else { return url }

        return appendingQueryParameters(url: url, addedParams ?? [])
    }

    private func appendingQueryParameters(url: URL, _ addedParams: [QueryParameter]) -> URL? {
        guard !addedParams.isEmpty else { return url }
        guard var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }

        let addedQueryItems = addedParams.map { name, value in URLQueryItem(
            name: name,
            value: value?.addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed4)
        ) }
        // if var percentEncodedQueryItems = urlComps.percentEncodedQueryItems, !percentEncodedQueryItems.isEmpty {
        //     percentEncodedQueryItems.append(contentsOf: addedQueryItems)
        //     urlComps.percentEncodedQueryItems = percentEncodedQueryItems
        // } else {
        urlComps.percentEncodedQueryItems = addedQueryItems
        // }

        return urlComps.url
    }

    public lazy var petoperation: PetOperation = PetOperation(client: self)

    // MARK: Public Client Methods
}
