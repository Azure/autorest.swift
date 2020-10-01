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
// swiftlint:disable cyclomatic_complexity

/// The full set of schemas for a given service, categorized into convenient collections.
class Schemas: Codable {
    /// a collection of items
    let arrays: [ArraySchema]?

    /// an associative array (ie, dictionary, hashtable, etc)
    let dictionaries: [DictionarySchema]?

    /// a true or false value
    let booleans: [BooleanSchema]?

    /// a number value
    let numbers: [NumberSchema]?

    /// an object of some type
    let objects: [ObjectSchema]?

    /// a string of characters
    let strings: [StringSchema]?

    /// UnixTime
    let unixTimes: [UnixTimeSchema]?

    /// an array of bytes
    let byteArrays: [ByteArraySchema]?

    let streams: [Schema]?

    /// a single characters
    let chars: [CharSchema]?

    /// a date
    let dates: [DateSchema]?

    /// a time
    let times: [TimeSchema]?

    /// a datetime
    let dateTimes: [DateTimeSchema]?

    /// a duration
    let durations: [DurationSchema]?

    /// a universally unique identifier
    let uuids: [UuidSchema]?

    /// a URI of some kind
    let uris: [UriSchema]?

    /// a password or credential
    let credentials: [CredentialSchema]?

    /// OData query
    let odataQueries: [ODataQuerySchema]?

    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unspecified value is permitted
    let choices: [ChoiceSchema]?

    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unknown value is not allowed
    let sealedChoices: [SealedChoiceSchema]?

    /// ie, when 'profile' is 'production', use '2018-01-01' for apiversion
    let conditionals: [ConditionalSchema]?

    let sealedConditionals: [SealedConditionalSchema]?

    let flags: [FlagSchema]?

    /// a constant value
    let constants: [ConstantSchema]?

    let ors: [OrSchema]?

    let xors: [XorSchema]?

    let binaries: [BinarySchema]?

    /// it's possible that we just may make this an error \nin representation.
    let unknowns: [Schema]?

    let groups: [GroupSchema]?

    let any: [AnySchema]?

    enum CodingKeys: String, CodingKey {
        case arrays
        case dictionaries
        case booleans
        case numbers
        case objects
        case strings
        case unixTimes = "unixtimes"
        case byteArrays
        case streams
        case chars
        case dates
        case times
        case dateTimes
        case durations
        case uuids
        case uris
        case credentials
        case odataQueries
        case choices
        case sealedChoices
        case conditionals
        case sealedConditionals
        case flags
        case constants
        case ors
        case xors
        case binaries
        case unknowns
        case groups
        case any
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        arrays = try? container.decode([ArraySchema].self, forKey: .arrays)
        dictionaries = try? container.decode([DictionarySchema].self, forKey: .dictionaries)
        booleans = try? container.decode([BooleanSchema].self, forKey: .booleans)
        numbers = try? container.decode([NumberSchema].self, forKey: .numbers)
        objects = try? container.decode([ObjectSchema].self, forKey: .objects)
        strings = try? container.decode([StringSchema].self, forKey: .strings)
        unixTimes = try? container.decode([UnixTimeSchema].self, forKey: .unixTimes)
        byteArrays = try? container.decode([ByteArraySchema].self, forKey: .byteArrays)
        streams = try? container.decode([Schema].self, forKey: .streams)
        chars = try? container.decode([CharSchema].self, forKey: .chars)
        dates = try? container.decode([DateSchema].self, forKey: .dates)
        times = try? container.decode([TimeSchema].self, forKey: .times)
        dateTimes = try? container.decode([DateTimeSchema].self, forKey: .dateTimes)
        durations = try? container.decode([DurationSchema].self, forKey: .durations)
        uuids = try? container.decode([UuidSchema].self, forKey: .uuids)
        uris = try? container.decode([UriSchema].self, forKey: .uris)
        credentials = try? container.decode([CredentialSchema]?.self, forKey: .credentials)
        odataQueries = try? container.decode([ODataQuerySchema].self, forKey: .odataQueries)
        choices = try? container.decode([ChoiceSchema].self, forKey: .choices)
        sealedChoices = try? container.decode([SealedChoiceSchema].self, forKey: .sealedChoices)
        conditionals = try? container.decode([ConditionalSchema].self, forKey: .conditionals)
        sealedConditionals = try? container.decode([SealedConditionalSchema].self, forKey: .sealedConditionals)
        flags = try? container.decode([FlagSchema].self, forKey: .flags)
        constants = try? container.decode([ConstantSchema].self, forKey: .constants)
        ors = try? container.decode([OrSchema].self, forKey: .ors)
        xors = try? container.decode([XorSchema].self, forKey: .xors)
        binaries = try? container.decode([BinarySchema]?.self, forKey: .binaries)
        unknowns = try? container.decode([Schema].self, forKey: .unknowns)
        groups = try? container.decode([GroupSchema].self, forKey: .groups)
        any = try? container.decode([AnySchema].self, forKey: .any)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if arrays != nil { try? container.encode(arrays, forKey: .arrays) }
        if dictionaries != nil { try? container.encode(dictionaries, forKey: .dictionaries) }
        if booleans != nil { try? container.encode(booleans, forKey: .booleans) }
        if numbers != nil { try? container.encode(numbers, forKey: .numbers) }
        if objects != nil { try? container.encode(objects, forKey: .objects) }
        if strings != nil { try? container.encode(strings, forKey: .strings) }
        if unixTimes != nil { try? container.encode(unixTimes, forKey: .unixTimes) }
        if byteArrays != nil { try? container.encode(byteArrays, forKey: .byteArrays) }
        if streams != nil { try? container.encode(streams, forKey: .streams) }
        if chars != nil { try? container.encode(chars, forKey: .chars) }
        if dates != nil { try? container.encode(dates, forKey: .dates) }
        if times != nil { try? container.encode(times, forKey: .times) }
        if dateTimes != nil { try? container.encode(dateTimes, forKey: .dateTimes) }
        if durations != nil { try? container.encode(durations, forKey: .durations) }
        if uuids != nil { try? container.encode(uuids, forKey: .uuids) }
        if uris != nil { try? container.encode(uris, forKey: .uris) }
        if credentials != nil { try? container.encode(credentials, forKey: .credentials) }
        if odataQueries != nil { try? container.encode(odataQueries, forKey: .odataQueries) }
        if choices != nil { try? container.encode(choices, forKey: .choices) }
        if sealedChoices != nil { try? container.encode(sealedChoices, forKey: .sealedChoices) }
        if conditionals != nil { try? container.encode(conditionals, forKey: .conditionals) }
        if sealedConditionals != nil { try? container.encode(sealedConditionals, forKey: .sealedConditionals) }
        if flags != nil { try? container.encode(flags, forKey: .flags) }
        if constants != nil { try? container.encode(constants, forKey: .constants) }
        if ors != nil { try? container.encode(ors, forKey: .ors) }
        if xors != nil { try? container.encode(xors, forKey: .xors) }
        if binaries != nil { try? container.encode(binaries, forKey: .binaries) }
        if unknowns != nil { try? container.encode(unknowns, forKey: .unknowns) }
        if groups != nil { try? container.encode(groups, forKey: .groups) }
        if any != nil { try? container.encode(any, forKey: .any) }
    }

    /// Lookup a schema by name.
    func schema(for name: String, withType type: AllSchemaTypes) -> Schema? {
        switch type {
        case .string:
            return strings?.first { $0.name == name }
        case .integer:
            return numbers?.first { $0.name == name }
        default:
            fatalError("Unhandled schema type: \(type)")
        }
    }
}
