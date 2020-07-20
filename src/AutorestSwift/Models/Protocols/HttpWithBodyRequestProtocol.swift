//
//  HttpWithBodyRequestProtocol.swift
//
//
//  Created by Sam Cheung on 2020-07-15.
//

import Foundation

public protocol HttpWithBodyRequestProtocol: HttpRequestProtocol {
    // canonical response type (ie, 'json')
    var knownMediaType: KnownMediaType { get set }

    // content returned by the service in the HTTP headers
    var mediaTypes: [String] { get set }
}
