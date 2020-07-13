//
//  Languages.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// Custom extensible metadata for individual language generators
public struct Languages: CodeModelProperty {

    public let properties: LanguagesProperties

    public let defaultProperties = [String]()

    public let additionalProperties = false
}

public struct LanguagesProperties: CodeModelPropertyBundle {
    public let `default`: Language

    public let csharp: CSharpLanguage?

    public let python: Language?

    public let ruby: Language?

    public let go: Language?

    public let typescript: Language?

    public let javascript: Language?

    public let powershell: Language?

    public let java: Language?

    public let c: Language?

    public let cpp: Language?

    public let swift: Language?

    public let objectiveC: Language?

    public let sputnik: Language?
}
