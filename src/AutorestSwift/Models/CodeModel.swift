//
//  CodeModel.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Model that contains all the information required to generate a service API
public class CodeModel: Codable {
    let info: Info
    let schemas: Schemas
    let operationGroups: [OperationGroup]
    let globalParameters: [Parameter]?
    let security: Security
    let language: Languages
    let `protocol`: Protocols
    let extensions: [String: Bool]?
}
