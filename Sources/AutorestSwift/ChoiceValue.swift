//
//  ChoiceValue.swift
//  
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

enum StringOrNumberOrBooleanError: Error {
    case decodeInvalidType
    case encodeInvalidType
}

/// an individual choice in a ChoiceSchema
public struct ChoiceValue: Codable {
    /// per-language information for this value
    public let language: Language

    /// the actual value
    public let value: StringOrNumberOrBoolean
    
    // TODO: Not Codable
    /// Additional metadata extensions dictionary
    //public let extensions: Dictionary<AnyHashable, Codable>?
}

public enum StringOrNumberOrBoolean: Codable {
    case string(String)
    case int(Int)
    case bool(Bool)
    
    public init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()

         if let string = try? container.decode(String.self) {
             self = .string(string)
         } else if let int = try? container.decode(Int.self) {
             self = .int(int)
         } else if let bool = try? container.decode(Bool.self) {
             self = .bool(bool)
         } else {
            throw StringOrNumberOrBooleanError.decodeInvalidType
         }
     }
     
     public func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         switch self {
         case .string(let string):
             try container.encode(string)
         case .int(let int):
             try container.encode(int)
         case .bool(let bool):
            try container.encode(bool)
         }
     }
     
}
