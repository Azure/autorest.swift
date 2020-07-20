//
//  Parameter.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// A definition of an discrete input for an operation
public protocol ParameterProtocol: ValueProtocol {
    /// suggested implementation location for this parameter
    var implementation: ImplementationLocation? { get set }

    /// When a parameter is flattened, it will be left in the list, but marked hidden (so, don't generate those!)
    var flattened: Bool? { get set }

    /// when a parameter is grouped into another, this will tell where the parameter got grouped into
    var groupedBy: ParameterProtocol? { get set }
}
