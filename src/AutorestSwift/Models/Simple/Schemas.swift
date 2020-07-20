//
//  Schemas.swift
//
//
//  Created by Travis Prescott on 7/9/20.
//

import Foundation

/// The full set of schemas for a given service, categorized into convenient collections.
public struct Schemas: Codable {
    /// a collection of items
    public var arrays: [ArraySchema]?

    /// an associative array (ie, dictionary, hashtable, etc)
    public var dictionaries: [DictionarySchema]?

    /// a true or false value
    public var booleans: [BooleanSchema]?

    /// a number value
    public var numbers: [NumberSchema]?

    /// an object of some type
    public var objects: [ObjectSchema]?

    /// a string of characters
    public var strings: [StringSchema]?

    /// UnixTime
    public var unixTimes: [UnixTimeSchema]?

    /// an array of bytes
    public var byteArrays: [ByteArraySchema]?

    public var streams: [SchemaProtocol]?

    /// a single characters
    public var chars: [CharSchema]?

    /// a date
    public var dates: [DateSchema]?

    /// a time
    public var times: [TimeSchema]?

    /// a datetime
    public var dateTimes: [DateTimeSchema]?

    /// a duration
    public var durations: [DurationSchema]?

    /// a universally unique identifier
    public var uuids: [UuidSchema]?

    /// a URI of some kind
    public var uris: [UriSchema]?

    /// a password or credential
    public var credentials: [CredentialSchema]?

    /// OData query
    public var odataQueries: [ODataQuerySchema]?

    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unspecified value is permitted
    public var choices: [ChoiceSchema]?

    /// this essentially can be thought of as an enum that is a choice between one of several items, but an unknown value is not allowed
    public var sealedChoices: [SealedChoiceSchema]?

    /// ie, when 'profile' is 'production', use '2018-01-01' for apiversion
    public var conditionals: [ConditionalSchema]?

    public var sealedConditionals: [SealedConditionalSchema]?

    public var flags: [FlagSchema]?

    /// a constant value
    public var constants: [ConstantSchema]?

    public var ors: [OrSchema]?

    public var xors: [XorSchema]?

    public var binaries: [BinarySchema]?

    /// it's possible that we just may make this an error \nin representation.
    public var unknowns: [SchemaProtocol]?

    public var groups: [GroupSchema]?

    public var any: [AnySchema]?
}
