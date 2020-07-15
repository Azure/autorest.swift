//
//  Schemas.swift
//  
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// The full set of schemas for a given service, categorized into convenient collections.
public struct Schemas: Codable {
    // TODO: Uncomment to slow enable YAML decoding

    //        /// a collection of items
    public let arrays: [ArraySchema]?

    //    /// an associative array (ie, dictionary, hashtable, etc)
    public let dictionaries: [DictionarySchema]?

    //    /// a true or false value
    public let booleans: [BooleanSchema]?

    //    /// a number value
    public let numbers: [NumberSchema]?
    //
    //    /// an object of some type
    //public let objects: [ObjectSchema]?
    //
    //    /// a string of characters
    public let strings: [StringSchema]?
    //
    //    /// UnixTime
    public let unixTimes: [UnixTimeSchema]?
    //
    //    /// an array of bytes
    public let byteArrays: [ByteArraySchema]?
    //
    public let streams: [Schema]?
    //
    //    /// a single characters
    public let chars: [CharSchema]?
    //
    //    /// a date
    public let dates: [DateSchema]?
    //
    //    /// a time
    public let times: [TimeSchema]?
    //
    //    /// a datetime
    public let dateTimes: [DateTimeSchema]?
    //
    //    /// a duration
    public let durations: [DurationSchema]?
    //
    //    /// a universally unique identifier
    public let uuids: [UuidSchema]?
    //
    //    /// a URI of some kind
    public let uris: [UriSchema]?
    //
    //    /// a password or credential
    public let credentials: [CredentialSchema]?
    //
    //    /// OData query
    public let odataQueries: [ODataQuerySchema]?
    //
    //    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unspecified value is permitted
    public let choices: [ChoiceSchema]?
    //
    //    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unknown value is not allowed
    public let sealedChoices: [SealedChoiceSchema]?
    //
    //    /// ie, when 'profile' is 'production', use '2018-01-01' for apiversion
    public let conditionals: [ConditionalSchema]?
    //
    public let sealedConditionals: [SealedConditionalSchema]?
    //
    public let flags: [FlagSchema]?
    //
    //    /// a constant value
    //public let constants: [ConstantSchema]?
    //
    public let ors: [OrSchema]?
    //
    public let xors: [XorSchema]?
    //
    public let binaries: [BinarySchema]?
    //
    //    /// it's possible that we just may make this an error \nin representation.
    public let unknowns: [Schema]?
    //
    public let groups: [GroupSchema]?
    //
    public let any: [AnySchema]?
}
