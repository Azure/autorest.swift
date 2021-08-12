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

import AutoRestSwaggerBatDictionary
import AzureCore
import XCTest

// swiftlint:disable type_body_length file_length
class AutoRestSwaggerBatDictionaryTest: XCTestCase {
    var client: AutoRestSwaggerBatDictionaryClient!
    var testDict = [
        "0": Widget(integer: 1, string: "2"),
        "1": Widget(integer: 3, string: "4"),
        "2": Widget(integer: 5, string: "6")
    ]

    let defaultTimeout = 5.0

    override func setUpWithError() throws {
        client = try AutoRestSwaggerBatDictionaryClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestSwaggerBatDictionaryClientOptions()
        )
    }

    func test_getBooleanTFFT() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getBooleanTfft { result, httpResponse in
            switch result {
            case let .success(data):
                let expected = ["0": true, "1": false, "2": false, "3": true]
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(booleanTfft: expected) { result, httpResponse in
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
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putBooleanTFFT() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let expected = ["0": true, "1": false, "2": false, "3": true]
        client.dictionary.put(booleanTfft: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getBooleanInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid = ["0": true, "1": nil, "2": false]

        client.dictionary.getBooleanInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getBooleanInvalidString() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getBooleanInvalidString { result, _ in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = error.errorDescription!
                XCTAssert(details.contains("Decoding error."))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getIntegerValid() throws {
        let expected: [String: Int32] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getIntegerValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putIntegerValid() throws {
        let expected: [String: Int32] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.put(integerValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getIntegerInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Int32?] = ["0": 1, "1": nil, "2": 0]

        client.dictionary.getIntInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getIntegerInvalidString() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getIntInvalidString { result, _ in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = error.errorDescription!
                XCTAssert(details.contains("Decoding error."))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getLongValid() throws {
        let expected: [String: Int64] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getLongValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putLongValid() throws {
        let expected: [String: Int64] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.put(longValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getLongInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Int64?] = ["0": 1, "1": nil, "2": 0]

        client.dictionary.getLongInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getLongInvalidString() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getLongInvalidString { result, _ in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = error.errorDescription!
                XCTAssert(details.contains("Decoding error."))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getFloatValid() throws {
        let expected: [String: Float?] = ["0": 0, "1": -0.01, "2": -1.2e20]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getFloatValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_putFloatValid() throws {
//        let expected: [String: Float?] = ["0": 0, "1": -0.01, "2": -1.2e20]
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//
//        // FIXME: Float serialization not accepted by server
//        client.dictionary.put(floatValid: expected) { result, httpResponse in
//            switch result {
//            case .success:
//                break
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    func test_getFloatInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Float?] = ["0": 0.0, "1": nil, "2": -1.2e20]

        client.dictionary.getFloatInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getFloatInvalidString() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getFloatInvalidString { result, _ in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = error.errorDescription!
                XCTAssert(details.contains("Decoding error."))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDoubleValid() throws {
        let expected: [String: Double] = ["0": 0, "1": -0.01, "2": -1.2e20]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDoubleValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putDoubleValid() throws {
        let expected: [String: Double] = ["0": 0, "1": -0.01, "2": -1.2e20]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(doubleValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDoubleInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Double?] = ["0": 0.0, "1": nil, "2": -1.2e20]

        client.dictionary.getDoubleInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDoubleInvalidString() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getDoubleInvalidString { result, _ in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = error.errorDescription!
                XCTAssert(details.contains("Decoding error."))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getStringValid() throws {
        let expected = ["0": "foo1", "1": "foo2", "2": "foo3"]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getStringValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putStringValid() throws {
        let expected = ["0": "foo1", "1": "foo2", "2": "foo3"]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(stringValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getStringNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let stringNullDict = ["0": "foo", "1": nil, "2": "foo2"]

        client.dictionary.getStringWithNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, stringNullDict)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_getStringInvalid() throws {
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//        let stringInvalidDict = ["0": "foo", "1": "123", "2": "foo2"]
//
//        // FIXME: Some crazy workaround behavior where autorest should deserialize non-string values
//        // as strings.
//        client.dictionary.getStringWithInvalid { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, stringInvalidDict)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    func test_getDateValid() throws {
        let expected: [String: SimpleDate] = [
            "0": SimpleDate(string: "2000-12-01")!,
            "1": SimpleDate(string: "1980-01-02")!,
            "2": SimpleDate(string: "1492-10-12")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDateValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putDateValid() throws {
        let expected: [String: SimpleDate] = [
            "0": SimpleDate(string: "2000-12-01")!,
            "1": SimpleDate(string: "1980-01-02")!,
            "2": SimpleDate(string: "1492-10-12")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(dateValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: SimpleDate?] = [
            "0": SimpleDate(string: "2012-01-01")!,
            "1": nil,
            "2": SimpleDate(string: "1776-07-04")!
        ]

        client.dictionary.getDateInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateInvalidChars() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDateInvalidChars { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateTimeValid() throws {
        let expected: [String: Iso8601Date] = [
            "0": Iso8601Date(string: "2000-12-01T00:00:01Z")!,
            "1": Iso8601Date(string: "1980-01-02T00:11:35+01:00")!,
            "2": Iso8601Date(string: "1492-10-12T10:15:01-08:00")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDateTimeValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putDateTimeValid() throws {
        let expected: [String: Iso8601Date] = [
            "0": Iso8601Date(string: "2000-12-01T00:00:01Z")!,
            "1": Iso8601Date(string: "1980-01-02T00:11:35+01:00")!,
            "2": Iso8601Date(string: "1492-10-12T10:15:01-08:00")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.put(dateTimeValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateTimeInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Iso8601Date?] = [
            "0": Iso8601Date(string: "2000-12-01T00:00:01Z")!,
            "1": nil
        ]

        client.dictionary.getDateTimeInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateTimeInvalidChars() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDateTimeInvalidChars { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDateTimeRfc1123Valid() throws {
        let expected: [String: Rfc1123Date] = [
            "0": Rfc1123Date(Iso8601Date(string: "2000-12-01T00:00:01Z")!.value)!,
            "1": Rfc1123Date(Iso8601Date(string: "1980-01-02T00:11:35Z")!.value)!,
            "2": Rfc1123Date(Iso8601Date(string: "1492-10-12T10:15:01Z")!.value)!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDateTimeRfc1123Valid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_putDateTimeRfc1123Valid() throws {
//        let expected: [String: Rfc1123Date] = [
//            "0": Rfc1123Date(Iso8601Date(string: "2000-12-01T00:00:01Z")!.value)!,
//            "1": Rfc1123Date(Iso8601Date(string: "1980-01-02T00:11:35Z")!.value)!,
//            "2": Rfc1123Date(Iso8601Date(string: "1492-10-12T10:15:01Z")!.value)!
//        ]
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//
//        // FIXME: Server not accepting the datetime serialization
//        client.dictionary.put(dateTimeRfc1123Valid: expected) { result, httpResponse in
//            switch result {
//            case .success:
//                break
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    func test_getDurationValid() throws {
        let expected: [String: Iso8601Duration] = [
            "0": Iso8601Duration(string: "P123DT22H14M12.011S")!,
            "1": Iso8601Duration(string: "P5DT1H")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDurationValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putDurationValid() throws {
        let expected: [String: Iso8601Duration] = [
            "0": Iso8601Duration(string: "P123DT22H14M12.011S")!,
            "1": Iso8601Duration(string: "P5DT1H")!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(durationValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getBytesValid() throws {
        let expected: [String: Data] = [
            "0": Data([0x0FF, 0x0FF, 0x0FF, 0x0FA]),
            "1": Data([0x01, 0x02, 0x03]),
            "2": Data([0x025, 0x029, 0x043])
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getByteValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putBytesValid() throws {
        let expected: [String: Data] = [
            "0": Data([0x0FF, 0x0FF, 0x0FF, 0x0FA]),
            "1": Data([0x01, 0x02, 0x03]),
            "2": Data([0x025, 0x029, 0x043])
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(byteValid: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getByteInvalidNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Data?] = [
            "0": Data([0x0AB, 0x0AC, 0x0AD]),
            "1": nil
        ]

        client.dictionary.getByteInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getBase64Url() throws {
        let expected: [String: String] = [
            "0": "a string that gets encoded with base64url".base64EncodedString(trimmingEquals: true),
            "1": "test string".base64EncodedString(trimmingEquals: true),
            "2": "Lorem ipsum".base64EncodedString(trimmingEquals: true)
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getBase64Url { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getEmpty() throws {
        let expected = [String: Int32]()
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putEmpty() throws {
        let expected = [String: Int32]()
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(empty: [String: String]()) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_getNull() throws {
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//
//        // FIXME: Not valid JSON. Domain Code=3840 No Value
//        client.dictionary.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertNil(data)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    func test_getInvalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getInvalid { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getNullKey() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getNullKey { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"), "\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getNullValue() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getNullValue { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, ["key1": nil])
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getEmptyStringKey() throws {
        let expected = ["": "val1"]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getEmptyStringKey { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getComplexNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getComplexNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getComplexEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getComplexEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.requestString, [String: Widget]().requestString)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_complexValid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(complexValid: testDict) { result, httpResponse in
            switch result {
            case .success:

                self.client.dictionary.getComplexValid { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data.requestString, self.testDict.requestString)
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
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getArrayValid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let listDict = [
            "0": ["1", "2", "3"],
            "1": ["4", "5", "6"],
            "2": ["7", "8", "9"]
        ]

        client.dictionary.getArrayValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, listDict)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putArrayValid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let listDict = [
            "0": ["1", "2", "3"],
            "1": ["4", "5", "6"],
            "2": ["7", "8", "9"]
        ]

        client.dictionary.put(arrayValid: listDict) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getDictionaryValid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDict: [String: [String: String?]?] = [
            "0": ["1": "one", "2": "two", "3": "three"],
            "1": ["4": "four", "5": "five", "6": "six"],
            "2": ["7": "seven", "8": "eight", "9": "nine"]
        ]

        client.dictionary.getDictionaryValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, dictDict)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putDictionaryValid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDict: [String: [String: String?]?] = [
            "0": ["1": "one", "2": "two", "3": "three"],
            "1": ["4": "four", "5": "five", "6": "six"],
            "2": ["7": "seven", "8": "eight", "9": "nine"]
        ]

        client.dictionary.put(dictionaryValid: dictDict) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getComplexItemNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let testDictNull = ["0": testDict["0"], "1": nil, "2": testDict["2"]]

        client.dictionary.getComplexItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.requestString, testDictNull.requestString)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getComplexItemEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let testDictEmpty = ["0": testDict["0"], "1": Widget(), "2": testDict["2"]]
        client.dictionary.getComplexItemEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.requestString, testDictEmpty.requestString)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getArrayNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getArrayNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getArrayEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getArrayEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [String: [String]]())
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getArrayItemNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let listDict = [
            "0": ["1", "2", "3"],
            "1": nil,
            "2": ["7", "8", "9"]
        ]

        client.dictionary.getArrayItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, listDict)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_getArrayItemEmpty() throws {
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//        let listDict = [
//            "0": ["1", "2", "3"],
//            "1": nil,
//            "2": ["7", "8", "9"]
//        ]
//        client.dictionary.getArrayItemEmpty { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data.requestString, listDict.requestString)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    // FIXME: See https://github.com/Azure/autorest.swift/issues/291
//    func test_getDictionaryNull() throws {
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//
//        client.dictionary.getDictionaryNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertNil(data)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. Error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: defaultTimeout)
//    }

    func test_getDictionaryEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDictionaryEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, [String: [String: String]]())
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_dictionaryItemNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDictNull: [String: [String: String?]?] = [
            "0": ["1": "one", "2": "two", "3": "three"],
            "1": nil,
            "2": ["7": "seven", "8": "eight", "9": "nine"]
        ]

        client.dictionary.getDictionaryItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.requestString, dictDictNull.requestString)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_dictionaryItemEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDictEmpty: [String: [String: String?]?] = [
            "0": ["1": "one", "2": "two", "3": "three"],
            "1": [String: String?](),
            "2": ["7": "seven", "8": "eight", "9": "nine"]
        ]

        client.dictionary.getDictionaryItemEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, dictDictEmpty)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }
}
