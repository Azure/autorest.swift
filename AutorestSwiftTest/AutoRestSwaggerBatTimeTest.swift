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

import AutoRestTimeTest
import AzureCore
import XCTest

class AutoRestSwaggerBatTimeTest: XCTestCase {
    var client: AutoRestTimeTestClient!

    override func setUpWithError() throws {
        client = try AutoRestTimeTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestTimeTestClientOptions()
        )
    }

    func test_get200() throws {
        let expectation = XCTestExpectation(description: "Call time.get")

        let timeString = "11:34:56"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        guard let expectedTime = dateFormatter.date(from: timeString) else {
            XCTFail("Input is not a date")
            return
        }

        client.time.get { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedTime)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_put200() throws {
        let expectation = XCTestExpectation(description: "Call time.put")

        let timeString = "08:07:56"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        guard let timeInput = dateFormatter.date(from: timeString) else {
            XCTFail("Input is not a date")
            return
        }

        client.time.put(timeBody: timeInput) { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
