//
//  CodeModel.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Model that contains all the information required to generate a service API
public struct CodeModel: Codable {
    let info: Info
    let schemas: Schemas
    let operationGroups: [OperationGroup]
    let globalParameters: [Parameter]?
    let security: Security
    let language: Languages
    let `protocol`: Protocols
    // TODO: Not Codable
    // let extensions: Dictionary<AnyHashable, Codable>?
}
