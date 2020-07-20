//
//  ChoiceValue.swift
//
//
//  Created by Sam Cheung on 2020-07-13.
//

import Foundation

// public enum StringOrNumberOrBoolean: String, Codable {
//    case string(String)
//    case int(Int)
//    case bool(Bool)
// }

/// an individual choice in a ChoiceSchema
public class ChoiceValue: Codable {
    /// per-language information for this value
    public let language: Languages

    /// the actual value
    // TODO: Resolve question about enum
    public let value: String // StringOrNumberOrBoolean

    /// Additional metadata extensions dictionary
    public let extensions: [String: Bool]?
    
     enum CodingKeys: String, CodingKey {
    case language, value, extensions
    }

    required public  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    language = try container.decode( Languages.self, forKey: .language)
        value = try container.decode( String.self, forKey: .value)
    extensions = try? container.decode( [String: Bool].self, forKey: .extensions)
  
    }
     public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(language, forKey: .language)
    try container.encode(value, forKey: .value)
   if extensions != nil { try container.encode(extensions, forKey: .extensions) }
    

    }

}
