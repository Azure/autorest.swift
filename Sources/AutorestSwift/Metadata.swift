//
//  Metadata.swift
//  
//
//  Created by Travis Prescott on 7/10/20.
//

import Foundation

/// Common pattern for Metadata on aspects
public struct Metadata: CodeModelProperty {
    public let properties: MetadataProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct MetadataProperties: CodeModelPropertyBundle {

    /// per-language information for this aspect
    public let language: Languages

    /// per-protocol information for this aspect
    public let `protocol`: Protocols

    /// additional metadata extensions dictionary
    public let extensions: Dictionary<AnyHashable, Codable>?
}
