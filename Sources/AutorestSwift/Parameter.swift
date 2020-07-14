//
//  Parameter.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// A definition of an discrete input for an operation
public struct Parameter: Codable {
    /// suggested implementation location for this parameter
    public let implementation: ImplementationLocation?

    /// When a parameter is flattened, it will be left in the list, but marked hidden (so, don't generate those!)
    public let flattened: Bool?

    /// when a parameter is grouped into another, this will tell where the parameter got grouped into
    // FIXME: Recursive cycle
    //public let groupedBy: Parameter?

    // TODO: Apply allOf
    // public let allOf: [Value]?
}
