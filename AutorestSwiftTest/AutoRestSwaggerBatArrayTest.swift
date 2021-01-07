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
        let expectation = XCTestExpectation(description: "Call array.listNull")

        client.arrayOperation.listNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listInvalid")

        client.arrayOperation.listInvalid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listEmpty")

        client.arrayOperation.listEmpty { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listBooleanTfft")

        client.arrayOperation.listBooleanTfft { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listBooleanInvalidNull")

        client.arrayOperation.listBooleanInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertEqual(details.data, "[ true, null, false ]")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getBooleanInvalidString200() throws {
        let expectation = XCTestExpectation(description: "Call array.listBooleanInvalidString")

        client.arrayOperation.listBooleanInvalidString { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to failed.")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertEqual(details.data, "[true, \"boolean\", false]")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getIntegerValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.listIntegerValid")

        client.arrayOperation.listIntegerValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listIntInvalidNull")

        client.arrayOperation.listIntInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listFloatWithString")

        client.arrayOperation.listIntInvalidString { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listLongValid")

        client.arrayOperation.listLongValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listLongInvalidNull")

        client.arrayOperation.listLongInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listLongInvalidString")

        client.arrayOperation.listLongInvalidString { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listFloatValid")

        client.arrayOperation.listFloatValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listFloatInvalidNull")

        client.arrayOperation.listFloatInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listFloatWithString")

        client.arrayOperation.listFloatInvalidString { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDoubleValid")

        client.arrayOperation.listDoubleValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDoubleInvalidNull")

        client.arrayOperation.listDoubleInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDoubleInvalidString")

        client.arrayOperation.listDoubleInvalidString { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listStringValid")

        client.arrayOperation.listStringValid { result, httpResponse in
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

    func test_getStringWithInvalid200() throws {
        let expectation = XCTestExpectation(description: "Call array.listStringWithInvalid")

        client.arrayOperation.listStringWithInvalid { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssertTrue(details.contains("\"foo\", 123, \"foo2\""))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getStringWithNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.listStringWithNull")

        let expectedData = ["foo", nil, "foo2"]
        client.arrayOperation.listStringWithNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                for i in 0 ..< data.count {
                    if let item = data[i] {
                        XCTAssertEqual(item, expectedData[i])
                    } else {
                        XCTAssertNil(expectedData[i])
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getEnumValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.listEnumValid")

        client.arrayOperation.listEnumValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listStringEnumValid")

        client.arrayOperation.listStringEnumValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listUuidValid")

        client.arrayOperation.listUuidValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDateInvalidNull")

        client.arrayOperation.listDateInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDateValid")
        let expectedDates = [
            SimpleDate(string: "2000-12-01")!,
            SimpleDate(string: "1980-01-02")!,
            SimpleDate(string: "1492-10-12")!
        ]

        client.arrayOperation.listDateValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDateTimeInvalidNull")

        client.arrayOperation.listDateTimeInvalidNull { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDateTimeValid")

        let expectedDates = [
            Iso8601Date(string: "2000-12-01t00:00:01z")!,
            Iso8601Date(string: "1980-01-02T01:11:35+01:00")!,
            Iso8601Date(string: "1492-10-12T02:15:01-08:00")!
        ]

        client.arrayOperation.listDateTimeValid { result, httpResponse in
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
        let expectation = XCTestExpectation(description: "Call array.listDateTimeRfc1123Valid")
        let expectedDates = [
            Rfc1123Date(string: "Fri, 01 Dec 2000 00:00:01 GMT")!,
            Rfc1123Date(string: "Wed, 02 Jan 1980 00:11:35 GMT")!,
            Rfc1123Date(string: "Wed, 12 Oct 1492 10:15:01 GMT")!
        ]
        client.arrayOperation.listDateTimeRfc1123Valid { result, httpResponse in
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

    func test_putDateValid() throws {
        let expectation = XCTestExpectation(description: "Call array.putDateValid")
        let expectedDates = [
            SimpleDate(string: "2000-12-01")!,
            SimpleDate(string: "1980-01-02")!,
            SimpleDate(string: "1492-10-12")!
        ]
        client.arrayOperation.put(dateValid: expectedDates) { result, httpResponse in
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

    func test_getByteValid() throws {
        let expectation = XCTestExpectation(description: "Call array.listByteValid")

        let expectedData = [
            Data([255, 255, 255, 250]),
            Data([1, 2, 3]),
            Data([37, 41, 67])
        ]
        client.arrayOperation.listByteValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, expectedData)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getByteInvalidNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.listByteInvalidNull")

        client.arrayOperation.listByteInvalidNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_puttByteValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.puttByteValid")

        let data = [
            Data([255, 255, 255, 250]),
            Data([1, 2, 3]),
            Data([37, 41, 67])
        ]
        client.arrayOperation.put(byteValid: data) { result, httpResponse in
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

    func test_getArrayValid() throws {
        let expectation = XCTestExpectation(description: "Call array.listArrayValid")

        client.arrayOperation.listArrayValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]])
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putArrayValid() throws {
        let expectation = XCTestExpectation(description: "Call array.putArrayValid")

        let data = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]

        client.arrayOperation.put(arrayValid: data) { result, httpResponse in
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

    func test_getArrayEmpty() throws {
        let expectation = XCTestExpectation(description: "Call array.listArrayEmpty")

        client.arrayOperation.listArrayEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, [])
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getArrayNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.listArrayNull")

        client.arrayOperation.listArrayNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getArrayItemEmpty() throws {
        let expectation = XCTestExpectation(description: "Call array.listArrayItemEmpty")

        client.arrayOperation.listArrayItemEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, [["1", "2", "3"], [], ["7", "8", "9"]])
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getArraygetArrayItemNull() throws {
        let expectation = XCTestExpectation(description: "Call array.listArrayItemNull")

        client.arrayOperation.listArrayItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, [["1", "2", "3"], nil, ["7", "8", "9"]])
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getComplexValid() throws {
        let expectation = XCTestExpectation(description: "Call array.listComplexValid")

        let expectedData: [Product] = [
            Product(integer: 1, string: "2"),
            Product(integer: 3, string: "4"),
            Product(integer: 5, string: "6")
        ]
        client.arrayOperation.listComplexValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                for i in 0 ..< data.count {
                    XCTAssertEqual(data[i].integer, expectedData[i].integer)
                }

            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getComplexEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call array.listComplexEmpty")

        client.arrayOperation.listComplexEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data.count, 0)

            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putComplexValid() throws {
        let expectation = XCTestExpectation(description: "Call array.putComplexValid")

        let data: [Product] = [
            Product(integer: 1, string: "2"),
            Product(integer: 3, string: "4"),
            Product(integer: 5, string: "6")
        ]
        client.arrayOperation.put(complexValid: data) { result, httpResponse in
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

    func test_getComplexNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.listComplexNull")

        client.arrayOperation.listComplexNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDictionaryValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.listDictionaryValid")

        let expectedData: [[String: String]] = [
            ["1": "one", "2": "two", "3": "three"],
            ["4": "four", "5": "five", "6": "six"],
            ["7": "seven", "8": "eight", "9": "nine"]
        ]
        client.arrayOperation.listDictionaryValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, expectedData)

            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDictionaryEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call array.listDictionaryEmpty")

        client.arrayOperation.listDictionaryEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, [])

            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDictionaryItemEmpty() throws {
        let expectation = XCTestExpectation(description: "Call array.listDictionaryItemEmpty")

        let expectedData: [[String: String]] = [
            ["1": "one", "2": "two", "3": "three"],
            [:],
            ["7": "seven", "8": "eight", "9": "nine"]
        ]
        client.arrayOperation.listDictionaryItemEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, expectedData)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDictionaryItemNull() throws {
        let expectation = XCTestExpectation(description: "Call array.listDictionaryItemNull")

        let expectedData: [[String: String]?] = [
            ["1": "one", "2": "two", "3": "three"],
            nil,
            ["7": "seven", "8": "eight", "9": "nine"]
        ]

        client.arrayOperation.listDictionaryItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, expectedData)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_getDictionaryNull200() throws {
        let expectation = XCTestExpectation(description: "Call array.listDictionaryNull")

        client.arrayOperation.listDictionaryNull { result, httpResponse in
            switch result {
            case .success:
                XCTFail("\(expectation.description) expected to fail.")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putDictionaryValid200() throws {
        let expectation = XCTestExpectation(description: "Call array.putDictionaryValid")

        let data: [[String: String]] = [
            ["1": "one", "2": "two", "3": "three"],
            ["4": "four", "5": "five", "6": "six"],
            ["7": "seven", "8": "eight", "9": "nine"]
        ]
        client.arrayOperation.put(dictionaryValid: data) { result, httpResponse in
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

    func test_getDurationValid() throws {
        let expected: [Iso8601Duration] = [
            Iso8601Duration(string: "P123DT22H14M12.011S")!,
            Iso8601Duration(string: "P5DT1H0M0S")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.arrayOperation.listDurationValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.arrayOperation.put(durationValid: expected) { result, httpResponse in
                    switch result {
                    case .success:
                        break
                    case let .failure(error):
                        let details = errorDetails(for: error, withResponse: httpResponse)
                        XCTFail("Call \(#function) failed. Error=\(details)")
                    }
                    expectation.fulfill()
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_putDurationValid() throws {
        let expected: [Iso8601Duration] = [
            Iso8601Duration(string: "P123DT22H14M12.011S")!,
            Iso8601Duration(string: "P5DT1H")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        // FIXME: Cannot parse ISO8601 duration string into DateComponents
        client.arrayOperation.put(durationValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
