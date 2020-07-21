//
//  CodeGenerator.swift
//  
//
//  Created by Travis Prescott on 7/21/20.
//

import Foundation

/// Common protocol for language code generators.
protocol CodeGenerator {
    // TODO: Promote methods from SwiftGenerator to here for use on something like
    // and ObjectiveC generator.

    var model: CodeModel { get }
}
