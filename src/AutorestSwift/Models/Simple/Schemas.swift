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
    let unixtimes: [UnixTimeSchema]?

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
