// --------------------------------------------------------------------------
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//
// The MIT License (MIT)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the ""Software""), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
//
// --------------------------------------------------------------------------

import Foundation

class Schema: Codable, LanguageShortcut {
    /// Per-language information for Schema
    public var language: Languages

    /// The schema type
    let type: AllSchemaTypes

    /// A short description
    let summary: String?

    /// Example information
    let example: String?

    /// If the value isn't sent on the wire, the service will assume this
    let defaultValue: String?

    /// Per-serialization information for this Schema
    let serialization: SerializationFormats?

    /// API versions that this applies to. Undefined means all versions
    let apiVersions: [ApiVersion]?

    /// Deprecation information -- ie, when this aspect doesn't apply and why
    let deprecated: Deprecation?

    /// Where did this aspect come from (jsonpath or 'modelerfour:<something>')
    let origin: String?

    /// External Documentation Links
    let externalDocs: ExternalDocumentation?

    /// Per-protocol information for this aspect
    let `protocol`: Protocols

    let properties: [Property]?

    /// Additional metadata extensions dictionary
    let extensions: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case language
        case type
        case summary
        case example
        case defaultValue
        case serialization
        case apiVersions
        case deprecated
        case origin
        case externalDocs
        case `protocol`
        case properties
        case extensions
    }

    func swiftType(optional: Bool = false) -> String {
        var swiftType: String
        switch type {
        case AllSchemaTypes.string:
            swiftType = "String"
        case AllSchemaTypes.boolean:
            swiftType = "Bool"
        case AllSchemaTypes.array:
            if let arraySchema = self as? ArraySchema {
                // If array element is String type, return an array of String instead of an array of Element Name and
                // then create a typealias for the ElementName and String
                if arraySchema.elementType as? StringSchema != nil {
                    swiftType = "[String]"
                } else {
                    swiftType = "[\(arraySchema.elementType.name)]"
                }
            } else {
                swiftType = "[\(name)]"
            }
        case AllSchemaTypes.dateTime,
             AllSchemaTypes.date,
             AllSchemaTypes.unixTime:
            swiftType = "Date"
        case AllSchemaTypes.byteArray:
            swiftType = "Data"
        case AllSchemaTypes.integer:
            swiftType = "Int"
        case AllSchemaTypes.choice,
             AllSchemaTypes.object,
             AllSchemaTypes.sealedChoice,
             AllSchemaTypes.group:
            swiftType = name
        case AllSchemaTypes.dictionary:
            if let dictionarySchema = self as? DictionarySchema {
                swiftType = "[String:\(dictionarySchema.elementType.swiftType())]"
            } else {
                swiftType = "[String:\(name)]"
            }
        case AllSchemaTypes.constant:
            guard let constant = self as? ConstantSchema else {
                fatalError("Type mismatch. Expected constant type but got \(self)")
            }
            swiftType = constant.valueType.swiftType()
        default:
            fatalError("Type \(type) not implemented")
        }

        return optional ? "\(swiftType)?" : swiftType
    }

    static func decode<Key>(
        withContainer container: KeyedDecodingContainer<Key>,
        useKey keyName: String = "schema"
    ) throws -> Schema? where Key: CodingKey {
        var schema: Schema?
        guard let keyEnum = Key(stringValue: keyName) else {
            fatalError("Unable to find key enum.")
        }
        do {
            let schemaContainer = try container.nestedContainer(keyedBy: Schema.CodingKeys.self, forKey: keyEnum)
            let type = try schemaContainer.decode(AllSchemaTypes.self, forKey: Schema.CodingKeys.type)
            switch type {
            case .array:
                schema = try container.decode(ArraySchema.self, forKey: keyEnum)
            case .dictionary:
                schema = try container.decode(DictionarySchema.self, forKey: keyEnum)
            case .object:
                schema = try container.decode(ObjectSchema.self, forKey: keyEnum)
            case .number, .integer:
                schema = try container.decode(NumberSchema.self, forKey: keyEnum)
            case .choice:
                schema = try container.decode(ChoiceSchema.self, forKey: keyEnum)
            case .dateTime:
                schema = try container.decode(DateTimeSchema.self, forKey: keyEnum)
            case .string:
                schema = try container.decode(StringSchema.self, forKey: keyEnum)
            case .constant:
                schema = try container.decode(ConstantSchema.self, forKey: keyEnum)
            case .byteArray:
                schema = try container.decode(ByteArraySchema.self, forKey: keyEnum)
            case .sealedChoice:
                schema = try container.decode(SealedChoiceSchema.self, forKey: keyEnum)
            default:
                schema = try container.decode(Schema.self, forKey: keyEnum)
            }
            return schema
        } catch {
            guard "\(error)".contains("but found Unresolved instead") else {
                throw error
            }
            return try? container.decode(Schema.self, forKey: keyEnum)
        }
    }
}
