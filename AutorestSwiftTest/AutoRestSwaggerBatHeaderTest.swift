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

import AutoRestSwaggerBatHeader
import AzureCore
import XCTest

class AutoRestSwaggerBatHeaderTest: XCTestCase {
    var client: AutoRestSwaggerBatHeaderClient!

    override func setUpWithError() throws {
        client = try AutoRestSwaggerBatHeaderClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestSwaggerBatHeaderClientOptions()
        )
    }

    func test_header_paramExistingKey200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramExistingKey")

        client.header.paramExistingKey(userAgent: "overwrite") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramExistingKey failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramProtectedKey200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramProtectedKey")

        client.header.paramProtectedKey(contentType: "text/html") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramProtectedKey failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramInteger200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramInteger")

        client.header.paramInteger(scenario: "positive", value: 1) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramInteger failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramLong200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramLong")

        client.header.paramLong(scenario: "negative", value: -2) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramLong failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramFloat200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramFloat")

        client.header.paramFloat(scenario: "positive", value: 0.07) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramFloat failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDouble200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDouble")

        client.header.paramDouble(scenario: "negative", value: -3.0) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDouble failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramBool200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramBool")

        client.header.paramBool(scenario: "true", value: true) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramBool failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramString200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramString")

        let options = Header.ParamStringOptions(
            value: "The quick brown fox jumps over the lazy dog"
        )

        client.header.paramString(scenario: "valid", withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramString failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDate200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDate")

        let dateString = "2010-01-01"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let date = dateFormatter.date(from: dateString) else {
            XCTFail("Input is not a date")
            return
        }

        client.header.paramDate(scenario: "valid", value: date) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDatetime200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDatetime")

        let dateString = "2010-01-01T12:34:56Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        guard let date = dateFormatter.date(from: dateString) else {
            XCTFail("Input is not a datetime")
            return
        }

        client.header.paramDatetime(scenario: "valid", value: date) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDatetime failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDatetimeRfc1123200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDatetimeRfc1123")

        let dateString = "Wed, 01 Jan 2010 12:34:56 GMT"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        guard let date = dateFormatter.date(from: dateString) else {
            XCTFail("Input is not a datetime")
            return
        }

        let options = Header.ParamDatetimeRfc1123Options(
            value: date
        )

        client.header.paramDatetimeRfc1123(scenario: "valid", withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDatetimeRfc1123 failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramEnum200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramEnum")

        let options = Header.ParamEnumOptions(
            value: .grey
        )

        client.header.paramEnum(scenario: "valid", withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramEnum failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramByte200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramByte")

        client.header.paramByte(
            scenario: "valid",
            value: "5ZWK6b2E5LiC54ub54uc76ex76Ss76ex76iM76ip".data(using: .utf8)!
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramEnum failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
