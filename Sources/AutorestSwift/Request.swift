//
//  Request.swift
//  
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

public struct Request: Codable {
    /// the parameter inputs to the operation
    public let parameters: [Parameter]?

    /// a filtered list of parameters that is (assumably) the actual method signature parameters
    public let signatureParameters: [Parameter]?

    // TODO: Apply allOf
    // public let allOf = [Metadata]
}
