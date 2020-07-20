//
//  HttpModel.swift
//
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

/// code model metadata for HTTP protocol
public struct HttpModel: ProtocolProtocol {
    /// a collection of security requirements for the service
    public var security: [SecurityRequirement]?
}
