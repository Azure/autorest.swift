//
//  Request.swift
//
//
//  Created by Travis Prescott on 7/14/20.
//

import Foundation

public class Request: Metadata {
    /// the parameter inputs to the operation
    public let parameters: [Parameter]?

    /// a filtered list of parameters that is (assumably) the actual method signature parameters
    public let signatureParameters: [Parameter]?
    
     enum CodingKeys: String, CodingKey {
    case parameters, signatureParameters
    }

    public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    parameters = try? container.decode( [Parameter]?.self, forKey: .parameters)
    signatureParameters = try? container.decode( [Parameter]?.self, forKey: .signatureParameters)
    try super.init(from: decoder)
    }
    override public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    if parameters != nil { try? container.encode(parameters, forKey: .parameters)}
    if signatureParameters != nil { try? container.encode(signatureParameters, forKey: .signatureParameters)}
     try super.encode(to: encoder)
    }
}
