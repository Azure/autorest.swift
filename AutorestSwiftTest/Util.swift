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

import AzureCore
import Foundation

private let allFormatOptions: [ISO8601DateFormatter.Options] = [
    [.withInternetDateTime, .withFractionalSeconds],
    [.withInternetDateTime]
]

func errorDetails(for error: AzureError, withResponse response: HTTPResponse?) -> String {
    var details: String
    if let data = response?.data {
        details = String(data: data, encoding: .utf8)!
    } else {
        details = error.message
    }
    return details
}

func iso8601date(from stringIn: String) -> Date? {
    let string = stringIn.hasSuffix("Z") ? stringIn : stringIn + "Z"
    let dateFormatter = ISO8601DateFormatter()
    for aformatOption in allFormatOptions {
        dateFormatter.formatOptions = aformatOption
        if let date = dateFormatter.date(from: string.capitalized) {
            return date
        }
    }
    return nil
}

func rfc1123date(from string: String) -> Date? {
    return Date.Format.rfc1123.formatter.date(from: string.capitalized)
}
