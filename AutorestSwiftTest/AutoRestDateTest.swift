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

import AutoRestDateTest
import AzureCore
import XCTest

class AutoRestDateTest: XCTestCase {
    var client: AutoRestDateTestClient!

    override func setUpWithError() throws {
        client = try AutoRestDateTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestDateTestClientOptions()
        )
    }

    func test_getNull200() throws {
        let expectation = XCTestExpectation(description: "Call date.getNull")

        client.dateOperation.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getNull failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getInvalidDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.getInvalidDate")

        client.dateOperation.getInvalidDate { result, httpResponse in
            switch result {
            case .success:
                XCTFail("date.getInvalid expected failed")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getOverflowDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.getOverflowDate")

        client.dateOperation.getOverflowDate { result, httpResponse in
            switch result {
            case .success:
                XCTFail("date.getOverflowDate expected failed")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getUnderflowDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.getUnderflowDate")

        client.dateOperation.getUnderflowDate { result, httpResponse in
            switch result {
            case .success:
                XCTFail("date.getUnderflowDate expected failed")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putMaxDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.putMaxDate")
        let dateString = "9999-12-31"
        let date = SimpleDate(string: dateString)!
        client.dateOperation.put(maxDate: date) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.putMaxDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getMaxDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.getMaxDate")
        let dateString = "9999-12-31"
        let expectedDate = SimpleDate(string: dateString)!
        client.dateOperation.getMaxDate { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.value, expectedDate.value)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getMaxDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putMinDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.putMinDate")
        let dateString = "0001-01-01"
        let expectedDate = SimpleDate(string: dateString)!
        client.dateOperation.put(minDate: expectedDate) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.putMinDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getMinDate200() throws {
        let expectation = XCTestExpectation(description: "Call date.getMinDate")
        let dateString = "0001-01-01"
        let date = SimpleDate(string: dateString)!
        client.dateOperation.getMinDate { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.value, date.value)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getMinDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
