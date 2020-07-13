//
//  CodeModel.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Model that contains all the information required to generate a service API
public struct CodeModel: CodeModelProperty {
    public let title = "CodeModel"

    // TODO: LOTS of these...
    public let definitions = [String: AnyObject]()

    public let additionalProperties = false

    public let defaultProperties = [String]()

    public let schema = "http://json-schema.org/draft-07/schema#"

    public let properties: CodeModelProperties
}

public struct CodeModelProperties: CodeModelPropertyBundle {
    let info: Info
    let schemas: Schemas
    let operationGroups: [OperationGroup]
    let globalParameters: [Parameter]?
    let security: Security
    let language: Languages
    let `protocol`: Protocols
    let extensions: Dictionary<AnyHashable, Codable>?
}
