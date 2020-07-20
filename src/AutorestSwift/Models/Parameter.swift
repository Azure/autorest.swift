//
//  Parameter.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// A definition of an discrete input for an operation
public class Parameter: Value {
    /// suggested implementation location for this parameter
    public let implementation: ImplementationLocation?

    /// When a parameter is flattened, it will be left in the list, but marked hidden (so, don't generate those!)
    public let flattened: Bool?

    /// when a parameter is grouped into another, this will tell where the parameter got grouped into
    public let groupedBy: Parameter?

    // MARK: Codable
  
    public enum CodingKeys: String, CodingKey {
        case implementation, flattened, schema, groupedBy
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        implementation = try? container.decode(ImplementationLocation.self, forKey: .implementation)
        flattened = try? container.decode(Bool.self, forKey: .flattened)
        groupedBy = try? container.decode(Parameter.self, forKey: .groupedBy)
      
        try super.init(from: decoder)

        if let constantSchema = try? container.decode(ConstantSchema.self, forKey: .schema) {
            super.schema = constantSchema
        } else if let numberSchema = try? container.decode(NumberSchema.self, forKey: .schema) {
            super.schema = numberSchema
        } else if let objectSchema = try? container.decode(ObjectSchema.self, forKey: .schema) {
            super.schema = objectSchema
        } else {
            super.schema = try container.decode(Schema.self, forKey: .schema)
        }
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if implementation != nil { try container.encode(implementation, forKey: .implementation) }
        if flattened != nil { try container.encode(flattened, forKey: .flattened) }

        try super.encode(to: encoder)
    }
}
