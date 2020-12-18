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
import PetStoreInc
import XCTest

class AutoRestEnumExtensibleTest: XCTestCase {
    var client: PetStoreIncClient!

    override func setUpWithError() throws {
        client = try PetStoreIncClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: PetStoreIncClientOptions()
        )
    }

//    func test_getLocalPositiveOffsetLowercaseMaxDateTime200() throws {
//        let expectation = XCTestExpectation(description: "Call datetime.getLocalPositiveOffsetLowercaseMaxDateTime")
//        let iso8601DateFormatter = ISO8601DateFormatter()
//        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        let expectedDate = iso8601DateFormatter.date(from: "9999-12-31t23:59:59.999+14:00".capitalized)!
//        client.datetime.getLocalPositiveOffsetLowercaseMaxDateTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data.value, expectedDate)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call date.getLocalPositiveOffsetLowercaseMaxDateTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
}
