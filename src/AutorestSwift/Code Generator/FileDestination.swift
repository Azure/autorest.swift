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

enum FileDestination {
    case root
    case tests
    case sources
    case models
    case operations
    case options
    case util
    case jazzy

    func url(forBaseUrl baseUrl: URL, withTargetName targetName: String) -> URL {
        switch self {
        case .root:
            return baseUrl
        case .tests:
            return baseUrl.appendingPathComponent("Tests")
        case .sources:
            return baseUrl.appendingPathComponent("Sources").appendingPathComponent(targetName)
        case .models:
            return baseUrl.appendingPathComponent("Sources").appendingPathComponent(targetName)
                .appendingPathComponent("Models")
        case .operations:
            return baseUrl.appendingPathComponent("Sources").appendingPathComponent(targetName)
                .appendingPathComponent("Operations")
        case .options:
            return baseUrl.appendingPathComponent("Sources").appendingPathComponent(targetName)
                .appendingPathComponent("Options")
        case .util:
            return baseUrl.appendingPathComponent("Sources").appendingPathComponent(targetName)
                .appendingPathComponent("Util")
        case .jazzy:
            return baseUrl.appendingPathComponent(".jazzy")
        }
    }
}
