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

    let properties: [PropertyType]?

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

    // swiftlint:disable cyclomatic_complexity
    func swiftType(optional: Bool = false) -> String {
        var swiftType: String
        switch type {
        case .any:
            swiftType = "AnyCodable"
        case .string,
             .uuid:
            swiftType = "String"
        case .boolean:
            swiftType = "Bool"
        case .array:
            guard let arraySchema = self as? ArraySchema else {
                fatalError("Type mismatch. Expected array type but got \(self)")
            }
            let elementSwiftType = arraySchema.elementType.swiftType()
            swiftType = (arraySchema.nullableItems ?? false) ? "[\(elementSwiftType)?]" : "[\(elementSwiftType)]"
        case .number:
            guard let numberSchema = self as? NumberSchema else {
                fatalError("Type mismatch. Expected number type but got \(self)")
            }
            swiftType = numberSchema.swiftType()
        case .dateTime:
            if let dateSchema = self as? DateTimeSchema {
                switch dateSchema.format {
                case .dateTime:
                    swiftType = "Iso8601Date"
                case .dateTimeRfc1123:
                    swiftType = "Rfc1123Date"
                }
            } else {
                fatalError("Type .dateTime but not schema `DateTimeSchema`")
            }
        case .date:
            swiftType = "SimpleDate"
        case .unixTime:
            swiftType = "UnixTime"
        case .byteArray:
            swiftType = "Data"
        case .integer:
            swiftType = "Int"
        case .time:
            swiftType = "SimpleTime"
        case .choice,
             .object,
             .sealedChoice,
             .group:
            swiftType = modelName
        case .dictionary:
            guard let dictionarySchema = self as? DictionarySchema else {
                fatalError("Type mismatch. Expected dictionary type but got \(self)")
            }
            swiftType = "[String:\(dictionarySchema.elementType.swiftType())?]"
        case .constant:
            guard let constant = self as? ConstantSchema else {
                fatalError("Type mismatch. Expected constant type but got \(self)")
            }
            swiftType = constant.valueType.swiftType()
        case .duration:
            swiftType = "Iso8601Duration"
        case .binary:
            swiftType = "Data"
        case .uri:
            swiftType = "URL"
        default:
            fatalError("Type \(type) not implemented")
        }
        return optional ? "\(swiftType)?" : swiftType
    }

    var modelName: String {
        return name.isReserved ? name + "Type" : name
    }

    var bodyParamStrategy: BodyParamStrategy {
        if self is ConstantSchema {
            return .constant
        }

        switch type {
        case .unixTime:
            return .unixTime
        case .byteArray:
            return .byteArray
        case .array:
            if let arraySchema = self as? ArraySchema,
                arraySchema.elementType.type == .date || arraySchema.elementType.type == .dateTime {
                return arraySchema.elementType.bodyParamStrategy
            } else {
                return .plain
            }
        case .time:
            return .time
        case .number:
            return (swiftType() == "Decimal") ? .decimal : .data
        default:
            return .plain
        }
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
