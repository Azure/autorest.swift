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

extension Header {
    /// User-configurable options for the `AutoRestSwaggerBATHeaderService.ParamDatetimeRfc1123` operation.
    public struct ParamDatetimeRfc1123Options: RequestOptions {
        /// Send a post request with header values "Wed, 01 Jan 2010 12:34:56 GMT" or "Mon, 01 Jan 0001 00:00:00 GMT"
        public let value: Rfc1123Date?

        /// A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
        /// Highly recommended for correlating client-side activites with requests received by the server.
        public let clientRequestId: String?

        /// A token used to make a best-effort attempt at canceling a request.
        public let cancellationToken: CancellationToken?

        /// A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
        public var dispatchQueue: DispatchQueue?

        /// A `PipelineContext` object to associate with the request.
        public var context: PipelineContext?

        /// Initialize a `ParamDatetimeRfc1123Options` structure.
        /// - Parameters:
        ///   - value: Send a post request with header values "Wed, 01 Jan 2010 12:34:56 GMT" or "Mon, 01 Jan 0001 00:00:00 GMT"
        ///   - clientRequestId: A client-generated, opaque value with 1KB character limit that is recorded in analytics logs.
        ///   - cancellationToken: A token used to make a best-effort attempt at canceling a request.
        ///   - dispatchQueue: A dispatch queue on which to call the completion handler. Defaults to `DispatchQueue.main`.
        ///   - context: A `PipelineContext` object to associate with the request.
        public init(
            value: Rfc1123Date? = nil,
            clientRequestId: String? = nil,
            cancellationToken: CancellationToken? = nil,
            dispatchQueue: DispatchQueue? = nil,
            context: PipelineContext? = nil
        ) {
            self.value = value
            self.clientRequestId = clientRequestId
            self.cancellationToken = cancellationToken
            self.dispatchQueue = dispatchQueue
            self.context = context
        }
    }
}
