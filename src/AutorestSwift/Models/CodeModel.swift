//
//  CodeModel.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Model that contains all the information required to generate a service API
public struct CodeModel: Codable {
    public let title = "CodeModel"

    public let schema = "http://json-schema.org/draft-07/schema#"

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
