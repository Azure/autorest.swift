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

/// Container for various README URLs.
struct ReadmeUrls {
    let source: String
    let api: String
    let product: String
    let samples: String
    let impressions: String
}

/// View Model for the README.md file.
struct ReadmeFileViewModel {
    let title: String
    let description: String
    let extendedDescription: String
    let urls: ReadmeUrls

    init(from model: CodeModel) {
        self.title = model.info.title
        self.description = model.info.description ?? ""
        self.extendedDescription = "TODO: Where?"
        self.urls = ReadmeUrls(
            source: "TODO: Find source URL",
            api: "TODO: Find API docs URL",
            product: "TODO: Find product documenation URL",
            samples: "TODO: Find samples URL",
            impressions: "TODO: Find impressions URL"
        )
    }
}
