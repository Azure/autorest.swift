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

import AutoRestSwaggerBatArray
import AzureCore
import XCTest

class AutoRestSwaggerBatArrayTest: XCTestCase {
    var client: AutoRestSwaggerBatArrayClient!

    override func setUpWithError() throws {
        client = try AutoRestSwaggerBatArrayClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestSwaggerBatArrayClientOptions()
        )
    }

    func test_getNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getNull")

        client.arrayOperation.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 0)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getNull failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getInvalid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getInvalid")

        client.arrayOperation.getInvalid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 0)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getInvalid failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call array.getEmpty")

        client.arrayOperation.getEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 0)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call array.putEmpty")

        client.arrayOperation.put(empty: []) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call putEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanTfft200() throws {
        let expectation = XCTestExpectation(description: "Call array.getBooleanTfft")

        client.arrayOperation.getBooleanTfft { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [true, false, false, true])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getBooleanTfft failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putBooleanTfft200() throws {
        let expectation = XCTestExpectation(description: "Call array.putBooleanTfft")

        client.arrayOperation.put(booleanTfft: [true, false, false, true]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call putBooleanTfft failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getBooleanInvalidNull")

        client.arrayOperation.getBooleanInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [true, nil, false])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getBooleanInvalidNull failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getBooleanInvalidString")

        client.arrayOperation.getBooleanInvalidString { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [true, nil, false])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getBooleanInvalidString failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getIntegerValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getIntegerValid")

        client.arrayOperation.getIntegerValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [1, -1, 3, 300])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getIntegerValid failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putIntegerValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putIntegerValid")

        client.arrayOperation.put(integerValid: [1, -1, 3, 300]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getIntegerValid failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
