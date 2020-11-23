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

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
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
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getInvalid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getInvalid")

        client.arrayOperation.getInvalid { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
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
                XCTFail("\(expectation.description) failed. error=\(details)")
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
                XCTFail("\(expectation.description) failed. error=\(details)")
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
                XCTFail("\(expectation.description) failed. error=\(details)")
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
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getBooleanInvalidNull")

        client.arrayOperation.getBooleanInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertEqual(details, "[ true, null, false ]")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getBooleanInvalidString")

        client.arrayOperation.getBooleanInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertEqual(details, "[true, \"boolean\", false]")
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
                XCTFail("\(expectation.description) failed. error=\(details)")
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
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getIntInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getIntInvalidNull")

        client.arrayOperation.getIntInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, null, 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getIntInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getFloatWithString")

        client.arrayOperation.getIntInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, \"integer\", 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLongValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getLongValid")

        client.arrayOperation.getLongValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [1, -1, 3, 300])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putLongValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putLongValid")

        client.arrayOperation.put(longValid: [1, -1, 3, 300]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLongInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getLongInvalidNull")

        client.arrayOperation.getLongInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, null, 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getLongInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getLongInvalidString")

        client.arrayOperation.getLongInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, \"integer\", 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getFloatValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getFloatValid")

        client.arrayOperation.getFloatValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [0, -0.01, -1.2e20])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getFloatInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getFloatInvalidNull")

        client.arrayOperation.getFloatInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("0.0, null, -1.2e20"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getFloatWithString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getFloatWithString")

        client.arrayOperation.getFloatInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, \"number\", 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDoubleValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDoubleValid")

        client.arrayOperation.getDoubleValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [0, -0.01, -1.2e20])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putDoubleValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putDoubleValid")

        client.arrayOperation.put(doubleValid: [0, -0.01, -1.2e20]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDoubleInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDoubleInvalidNull")

        client.arrayOperation.getDoubleInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("0.0, null, -1.2e20"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDoubleInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDoubleInvalidString")

        client.arrayOperation.getDoubleInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("1, \"number\", 0"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getStringValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getStringValid")

        client.arrayOperation.getStringValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, ["foo1", "foo2", "foo3"])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putStringValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putStringValid")

        client.arrayOperation.put(stringValid: ["foo1", "foo2", "foo3"]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getStringWithNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getStringWithNull")

        client.arrayOperation.getStringWithNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("\"foo\", null, \"foo2\""))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getEnumValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getEnumValid")

        client.arrayOperation.getEnumValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [FooEnum.foo1, FooEnum.foo2, FooEnum.foo3])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putEnumValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putEnumValid")

        client.arrayOperation.put(enumValid: [FooEnum.foo1, FooEnum.foo2, FooEnum.foo3]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getStringEnumValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getStringEnumValid")

        client.arrayOperation.getStringEnumValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [Enum0.foo1, Enum0.foo2, Enum0.foo3])
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putStringEnumValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putStringEnumValid")

        client.arrayOperation.put(stringEnumValid: [Enum1.foo1, Enum1.foo2, Enum1.foo3]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getUuidValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getUuidValid")

        client.arrayOperation.getUuidValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(
                    data,
                    [
                        "6dcc7237-45fe-45c4-8a6b-3a8a3f625652",
                        "d1399005-30f7-40d6-8da6-dd7c89ad34db",
                        "f42f6aa1-a5bc-4ddf-907e-5f915de43205"
                    ]
                )
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putUuidValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putUuidValid")

        client.arrayOperation.put(uuidValid: [
            "6dcc7237-45fe-45c4-8a6b-3a8a3f625652",
            "d1399005-30f7-40d6-8da6-dd7c89ad34db",
            "f42f6aa1-a5bc-4ddf-907e-5f915de43205"
        ]) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func getDateInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call array.getDateInvalidNull")

        client.arrayOperation.getDateInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("\"foo\", null, \"foo2\""))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listDateInvalidChars200() throws {
        let expectation = XCTestExpectation(description: "Call array.listDateInvalidChars")

        client.arrayOperation.listDateInvalidChars { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("[\"2011-03-22\", \"date\"]"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDateValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDateValid")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expectedDates = [
            dateFormatter.date(from: "2000-12-01"),
            dateFormatter.date(from: "1980-01-02"),
            dateFormatter.date(from: "1492-10-12")
        ]

        client.arrayOperation.getDateValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDates)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDateTimeInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDateTimeInvalidNull")

        client.arrayOperation.getDateTimeInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("\"2000-12-01t00:00:01z\", null"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listDateTimeInvalidChars200() throws {
        let expectation = XCTestExpectation(description: "Call array.listDateTimeInvalidChars")

        client.arrayOperation.listDateTimeInvalidChars { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("date-time"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDateTimeValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDateTimeValid")

        let expectedDates = [
            iso8601date(from: "2000-12-01t00:00:01z"),
            iso8601date(from: "1980-01-02T01:11:35+01:00"),
            iso8601date(from: "1492-10-12T02:15:01-08:00")
        ]

        client.arrayOperation.getDateTimeValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDates)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDateTimeRfc1123Valid200() throws {
        let expectation = XCTestExpectation(description: "Call array.getDateTimeRfc1123Valid")

        let expectedDates = [
            rfc1123date(from: "Fri, 01 Dec 2000 00:00:01 GMT"),
            rfc1123date(from: "Wed, 02 Jan 1980 00:11:35 GMT"),
            rfc1123date(from: "Wed, 12 Oct 1492 10:15:01 GMT")
        ]

        client.arrayOperation.getDateTimeRfc1123Valid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expectedDates)
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
