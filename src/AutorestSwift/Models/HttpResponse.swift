//
//  File.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public enum HttpResponseStatusCode: String, Codable {
    case _100 = "100"
    case _101 = "101"
    case _102 = "102"
    case _103 = "103"
    case _200 = "200"
    case _201 = "201"
    case _202 = "202"
    case _203 = "203"
    case _204 = "204"
    case _205 = "205"
    case _206 = "206"
    case _207 = "207"
    case _208 = "208"
    case _226 = "226"
    case _300 = "300"
    case _301 = "301"
    case _302 = "302"
    case _303 = "303"
    case _304 = "304"
    case _305 = "305"
    case _306 = "306"
    case _307 = "307"
    case _308 = "308"
    case _400 = "400"
    case _401 = "401"
    case _402 = "402"
    case _403 = "403"
    case _404 = "404"
    case _405 = "405"
    case _406 = "406"
    case _407 = "407"
    case _408 = "408"
    case _409 = "409"
    case _410 = "410"
    case _411 = "411"
    case _412 = "412"
    case _413 = "413"
    case _414 = "414"
    case _415 = "415"
    case _416 = "416"
    case _417 = "417"
    case _418 = "418"
    case _421 = "421"
    case _422 = "422"
    case _423 = "423"
    case _424 = "424"
    case _425 = "425"
    case _426 = "426"
    case _428 = "428"
    case _429 = "429"
    case _431 = "431"
    case _451 = "451"
    case _500 = "500"
    case _501 = "501"
    case _502 = "502"
    case _503 = "503"
    case _504 = "504"
    case _505 = "505"
    case _506 = "506"
    case _507 = "507"
    case _508 = "508"
    case _510 = "510"
    case _511 = "511"
    case `default` = "default"
}

public struct HttpResponse: CodeModelProtocol {
    // the possible HTTP status codes that this response MUST match one of.
    public let statusCodes: [HttpResponseStatusCode]

    // canonical response type (ie, 'json')
    public let knownMediaType: KnownMediaType

    // the possible media types that this response MUST match one of
    public let mediaTypes: [String]

    // content returned by the service in the HTTP headers
    public let headers: [HttpHeader]?

    // sets of HTTP headers grouped together into a single schema
    public let headerGroups: [GroupSchema]?
}
