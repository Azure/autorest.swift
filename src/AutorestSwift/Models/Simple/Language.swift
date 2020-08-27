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

/// The bare-minimum fields for per-language metadata on a given aspect
class Language: Codable {
    // MARK: Properties

    /// name used in actual implementation
    public var name: String

    /// description text - describes this node.
    public var description: String

    public var summary: String?

    public var serializedName: String?

    public var namespace: String?

    // MARK: AdditionalProperties

    struct PagingNames: Codable {
        var itemName: String
        var nextLinkName: String

        init?(from dict: [String: String]) {
            guard let itemName = dict["itemName"],
                let nextLinkName = dict["nextLinkName"] else { return nil }
            self.itemName = itemName
            self.nextLinkName = nextLinkName
        }
    }

    public var paging: PagingNames?

    // MARK: Initializers

    public init(from original: Language) {
        self.name = original.name
        self.description = original.description
        self.summary = original.summary
        self.serializedName = original.serializedName
        self.namespace = original.namespace
        self.paging = original.paging
    }
}
