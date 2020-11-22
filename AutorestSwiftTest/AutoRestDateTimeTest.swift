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

import AutoRestDateTimeTest
import AzureCore
import XCTest

class AutoRestDateTimeTest: XCTestCase {
    var client: AutoRestDateTimeTestClient!

    override func setUpWithError() throws {
        client = try AutoRestDateTimeTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestDateTimeTestClientOptions()
        )
    }

    func test_getNull200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getNull")

        client.datetime.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call datetime.getNull failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getInvalidDate200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getInvalid")

        client.datetime.getInvalid { result, httpResponse in
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

    func test_getOverflow200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getOverflow")

        client.datetime.getOverflow { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call datetime.getOverflow failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getUnderflow200() throws {
        let expectation = XCTestExpectation(description: "Call date.getUnderflow")

        client.datetime.getUnderflow { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call datetime.putMaxDate")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso8601DateFormatter.date(from: "9999-12-31T23:59:59.999Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.put(utcMaxDateTime: date) { result, httpResponse in
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

    func test_getUtcUppercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getUtcUppercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31T23:59:59.999Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getUtcUppercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getUtcUppercaseMaxDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putMinDate200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.putMinDate")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = iso8601DateFormatter.date(from: "0001-01-01T00:00:00.000Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.put(utcMinDateTime: date) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call datetime.putMinDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getUtcMinDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getUtcMinDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        guard let expectedDate = iso8601DateFormatter.date(from: "0001-01-01T00:00:00Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getUtcMinDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getUtcMinDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalPositiveOffsetUppercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalPositiveOffsetUppercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31T23:59:59.999+14:00") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalPositiveOffsetUppercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalPositiveOffsetUppercaseMaxDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalPositiveOffsetMinDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalPositiveOffsetMinDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        guard let expectedDate = iso8601DateFormatter.date(from: "0001-01-01T00:00:00+14:00") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalPositiveOffsetMinDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalPositiveOffsetMinDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalNegativeOffsetUppercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalNegativeOffsetUppercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31T23:59:59.999-14:00") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalNegativeOffsetUppercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalNegativeOffsetUppercaseMaxDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalNegativeOffsetLowercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalNegativeOffsetLowercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31t23:59:59.999-14:00".capitalized) else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalNegativeOffsetLowercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getDateTimeRfc1123MaxUtcLowercase failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalPositiveOffsetLowercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalPositiveOffsetLowercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31t23:59:59.999+14:00".capitalized) else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalPositiveOffsetLowercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalPositiveOffsetLowercaseMaxDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalNoOffsetMinDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalNoOffsetMinDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        guard let expectedDate = iso8601DateFormatter.date(from: "0001-01-01T00:00:00Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalNoOffsetMinDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalNoOffsetMinDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getUtcLowercaseMaxDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getUtcLowercaseMaxDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let expectedDate = iso8601DateFormatter.date(from: "9999-12-31t23:59:59.999z".capitalized) else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getUtcLowercaseMaxDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getUtcLowercaseMaxDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLocalNegativeOffsetMinDateTime200() throws {
        let expectation = XCTestExpectation(description: "Call datetime.getLocalNegativeOffsetMinDateTime")

        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime]
        guard let expectedDate = iso8601DateFormatter.date(from: "0001-01-01T00:00:00-14:00Z") else {
            XCTFail("Input is not a datetime")
            return
        }

        client.datetime.getLocalNegativeOffsetMinDateTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDate)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call date.getLocalNegativeOffsetMinDateTime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
