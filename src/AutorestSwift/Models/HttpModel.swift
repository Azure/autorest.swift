//
//  HttpModel.swift
//  
//
//  Created by Travis Prescott on 7/16/20.
//

import Foundation

typealias HttpModel = Protocol<HttpModelProperties>

/// code model metadata for HTTP protocol
public class HttpModelProperties: Codable {
    /// a collection of security requirements for the service
    public let security: [SecurityRequirement]
}
