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
// swiftlint:disable identifier_name
// swiftlint:disable line_length

extension AutoRestReportServiceForAzure {
    /// User-configurable options for the `AutoRestReportServiceForAzure.GetReport` operation.
    public struct GetReportOptions: RequestOptions {
        /// If specified, qualifies the generated report further (e.g. '2.7' vs '3.5' in for Python). The only effect is, that generators that run all tests several times, can distinguish the generated reports.
        public let qualifier: String?

        /// A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
        /// Highly recommended for correlating client-side activites with requests received by the server.
        public let clientRequestId: String?

        /// A token used to make a best-effort attempt at canceling a request.
        public let cancellationToken: CancellationToken?

        /// A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
        public var dispatchQueue: DispatchQueue?

        /// Initialize a `GetReportOptions` structure.
        /// - Parameters:
        ///   - qualifier: If specified, qualifies the generated report further (e.g. '2.7' vs '3.5' in for Python). The only effect is, that generators that run all tests several times, can distinguish the generated reports.
        ///   - clientRequestId: A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
        ///   - cancellationToken: A token used to make a best-effort attempt at canceling a request.
        ///   - dispatchQueue: A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
        public init(
            qualifier: String? = nil,
            clientRequestId: String? = nil,
            cancellationToken: CancellationToken? = nil,
            dispatchQueue: DispatchQueue? = nil
        ) {
            self.qualifier = qualifier
            self.clientRequestId = clientRequestId
            self.cancellationToken = cancellationToken
            self.dispatchQueue = dispatchQueue
        }
    }
}