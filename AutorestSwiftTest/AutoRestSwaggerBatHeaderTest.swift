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

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
class AutoRestSwaggerBatHeaderTest: XCTestCase {
    var client: AutoRestSwaggerBatHeaderClient!

    override func setUpWithError() throws {
        client = try AutoRestSwaggerBatHeaderClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestSwaggerBatHeaderClientOptions()
        )
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
        }

        client.header.paramInteger(scenario: "negative", value: -2) { result, httpResponse in
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

    func test_header_responseInteger200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramInteger")

        client.header.responseInteger(scenario: "positive") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "1")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramInteger failed. error=\(details)")
            }
        }

        client.header.responseInteger(scenario: "negative") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "-2")
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

        client.header.paramLong(scenario: "positive", value: 105) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramLong failed. error=\(details)")
            }
        }

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

    func test_header_responseLong200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseLong")

        client.header.responseLong(scenario: "positive") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "105")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseLong failed. error=\(details)")
            }
        }

        client.header.responseLong(scenario: "negative") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "-2")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseLong failed. error=\(details)")
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
        }

        client.header.paramFloat(scenario: "negative", value: -3.0) { result, httpResponse in
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

    func test_header_responseFloat200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseFloat")

        client.header.responseFloat(scenario: "positive") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "0.07")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseFloat failed. error=\(details)")
            }
        }

        client.header.responseFloat(scenario: "negative") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "-3")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseFloat failed. error=\(details)")
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

    func test_header_responseDouble200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseDouble")

        client.header.responseDouble(scenario: "negative") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "-3")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseDouble failed. error=\(details)")
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
        }

        client.header.paramBool(scenario: "false", value: false) { result, httpResponse in
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

    func test_header_responseBool200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseBool")

        client.header.responseBool(scenario: "true") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "true")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseBool failed. error=\(details)")
            }
        }

        client.header.responseBool(scenario: "false") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "false")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.responseBool failed. error=\(details)")
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

        let emptyOptions = Header.ParamStringOptions(
            value: ""
        )
        client.header.paramString(scenario: "empty", withOptions: emptyOptions) { result, httpResponse in
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

    func test_header_responseString200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseString")

        client.header.responseString(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "The quick brown fox jumps over the lazy dog")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
            expectation.fulfill()
        }

        client.header.responseString(scenario: "empty") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDate200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDate")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        let dateString = "2010-01-01"
        let minDateString = "0001-01-01"
        guard let date = dateFormatter.date(from: dateString) else {
            XCTFail("Input is not a date")
            return
        }
        guard let minDate = dateFormatter.date(from: minDateString) else {
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
        }

        client.header.paramDate(scenario: "min", value: minDate) { result, httpResponse in
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

    func test_header_responseDate200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseDate")

        client.header.responseDate(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "2010-01-01")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
        }

        client.header.responseDate(scenario: "min") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "0001-01-01")
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

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        let dateString = "2010-01-01T12:34:56Z"
        guard let date = dateFormatter.date(from: dateString) else {
            XCTFail("Input is not a datetime")
            return
        }

        let minDateString = "0001-01-01T00:00:00Z"
        guard let minDate = dateFormatter.date(from: minDateString) else {
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
        }

        client.header.paramDatetime(scenario: "min", value: minDate) { result, httpResponse in
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

    func test_header_responseDatetime200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseDatetime")

        client.header.responseDatetime(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "2010-01-01T12:34:56Z")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
        }

        client.header.responseDatetime(scenario: "min") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "0001-01-01T00:00:00Z")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_header_paramDatetimeRfc1123200() throws {
        let expectation = XCTestExpectation(description: "Call header.paramDatetimeRfc1123")

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"

        let dateString = "Wed, 01 Jan 2010 12:34:56 GMT"
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

    func test_header_responseDatetimeRfc1123_200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseDatetimeRfc1123")

        client.header.responseDatetimeRfc1123(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "Fri, 01 Jan 2010 12:34:56 GMT")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
        }
        client.header.responseDatetimeRfc1123(scenario: "min") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "Mon, 01 Jan 0001 00:00:00 GMT")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
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

    func test_header_responseEnum200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseEnum")

        client.header.responseEnum(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "GREY")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
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

    func test_header_responseByte200() throws {
        let expectation = XCTestExpectation(description: "Call header.responseByte")

        client.header.responseByte(scenario: "valid") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(httpResponse?.headers["value"], "5ZWK6b2E5LiC54ub54uc76ex76Ss76ex76iM76ip")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call header.paramDate failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
