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

    func test_boolean_tfft() throws {
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

    func test_getBoolean_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid = ["0": true, "1": nil, "2": false]

        client.dictionary.getBooleanInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getBooleanInvalidString { result, _ in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = error.errorDescription!
                        XCTAssert(details.contains("Decoding error."))
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

    func test_integer_valid() throws {
        let expected: [String: Int32] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getIntegerValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(integerValid: expected) { result, httpResponse in
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

    func test_getInteger_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Int32?] = ["0": 1, "1": nil, "2": 0]

        client.dictionary.getIntInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getIntInvalidString { result, _ in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = error.errorDescription!
                        XCTAssert(details.contains("Decoding error."))
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

    func test_long_valid() throws {
        let expected: [String: Int64] = ["0": 1, "1": -1, "2": 3, "3": 300]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getLongValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(longValid: expected) { result, httpResponse in
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

    func test_getLong_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Int64?] = ["0": 1, "1": nil, "2": 0]

        client.dictionary.getLongInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getLongInvalidString { result, _ in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = error.errorDescription!
                        XCTAssert(details.contains("Decoding error."))
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

    func test_float_valid() throws {
        let expected: [String: Float?] = ["0": 0, "1": -0.01, "2": -1.2e20]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getFloatValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                // FIXME: Float serialization not accepted by server
                self.client.dictionary.put(floatValid: expected) { result, httpResponse in
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

    func test_getFloat_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Float?] = ["0": 0.0, "1": nil, "2": -1.2e20]

        client.dictionary.getFloatInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getFloatInvalidString { result, _ in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = error.errorDescription!
                        XCTAssert(details.contains("Decoding error."))
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

    func test_double_valid() throws {
        let expected: [String: Double] = ["0": 0, "1": -0.01, "2": -1.2e20]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getDoubleValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(doubleValid: expected) { result, httpResponse in
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

    func test_getDouble_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Double?] = ["0": 0.0, "1": nil, "2": -1.2e20]

        client.dictionary.getDoubleInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getDoubleInvalidString { result, _ in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = error.errorDescription!
                        XCTAssert(details.contains("Decoding error."))
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

    func test_string_valid() throws {
        let expected = ["0": "foo1", "1": "foo2", "2": "foo3"]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getStringValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(stringValid: expected) { result, httpResponse in
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

    func test_getString_nullAndInvalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let stringNullDict = ["0": "foo", "1": nil, "2": "foo2"]
        let stringInvalidDict = ["0": "foo", "1": "123", "2": "foo2"]

        client.dictionary.getStringWithNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, stringNullDict)

                // FIXME: Some crazy workaround behavior where autorest should deserialize non-string values
                // as strings.
                self.client.dictionary.getStringWithInvalid { result, httpResponse in
                    switch result {
                    case .success:
                        XCTAssertEqual(data, stringInvalidDict)
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

    func test_date_valid() throws {
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

                self.client.dictionary.put(dateValid: expected) { result, httpResponse in
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

    func test_getDate_invalid() throws {
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

                self.client.dictionary.getDateInvalidChars { result, httpResponse in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = errorDetails(for: error, withResponse: httpResponse)
                        XCTAssert(details.contains("Deserialization error"))
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_dateTime_valid() throws {
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

                self.client.dictionary.put(dateTimeValid: expected) { result, httpResponse in
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

    func test_getDateTime_invalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let invalid: [String: Iso8601Date?] = [
            "0": Iso8601Date(string: "2000-12-01T00:00:01Z")!,
            "1": nil
        ]

        client.dictionary.getDateTimeInvalidNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, invalid)

                self.client.dictionary.getDateTimeInvalidChars { result, httpResponse in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = errorDetails(for: error, withResponse: httpResponse)
                        XCTAssert(details.contains("Deserialization error"))
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_dateTimeRfc1123_valid() throws {
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

                // FIXME: Server not accepting the datetime serialization
                self.client.dictionary.put(dateTimeRfc1123Valid: expected) { result, httpResponse in
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

    func test_getDuration_valid() throws {
        let expected: [String: DateComponents] = [
            "0": DateComponents(day: 123, hour: 22, minute: 14, second: 12, nanosecond: 11000),
            "1": DateComponents(day: 5, hour: 1)
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        // FIXME: Cannot parse ISO8601 duration string into DateComponents
        client.dictionary.getDurationValid { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(durationValid: expected) { result, httpResponse in
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

    func test_bytes_valid() throws {
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

                self.client.dictionary.put(byteValid: expected) { result, httpResponse in
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

    func test_getByte_invalidNull() throws {
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

    func test_base64Url() throws {
        let expected: [String: Data] = [
            "0": Data(base64Encoded: "a string that gets encoded with base64url".base64EncodedString())!,
            "1": Data(base64Encoded: "test string".base64EncodedString())!,
            "2": Data(base64Encoded: "Lorem ipsum".base64EncodedString())!
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")

        // FIXME: Data couldn't be read because it's in the wrong format.
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

    func test_empty() throws {
        let expected = [String: Int32]()
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)

                self.client.dictionary.put(empty: [String: String]()) { result, httpResponse in
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

    func test_get_nullAndInvalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        // FIXME: Not valid JSON. Domain Code=3840 No Value
        client.dictionary.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)

                self.client.dictionary.getInvalid { result, httpResponse in
                    switch result {
                    case .success:
                        XCTFail("Call \(#function) succeeded but should have failed.")
                    case let .failure(error):
                        let details = errorDetails(for: error, withResponse: httpResponse)
                        XCTAssert(details.contains("Decode error"))
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

    func test_get_nullKeyAndValue() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.dictionary.getNullKey { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"), "\(details)")

                self.client.dictionary.getNullValue { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, ["key1": nil])
                    case let .failure(error):
                        let details = errorDetails(for: error, withResponse: httpResponse)
                        XCTFail("Call \(#function) failed. Error=\(details)")
                    }
                    expectation.fulfill()
                }
            }
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_get_emptyStringKey() throws {
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

    func test_getComplex_nullAndEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getComplexNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)

                self.client.dictionary.getComplexEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, [String: Widget]())
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

    func test_complex_valid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.put(complexValid: testDict) { result, httpResponse in
            switch result {
            case .success:

                self.client.dictionary.getComplexValid { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, self.testDict)
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

    func test_array_valid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let listDict = [
            "0": ["1", "2", "3"],
            "1": ["4", "5", "6"],
            "2": ["7", "8", "9"]
        ]

        client.dictionary.put(arrayValid: listDict) { result, httpResponse in
            switch result {
            case .success:
                self.client.dictionary.getArrayValid { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, listDict)
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

    func test_dictionary_valid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDict: [String: AnyCodable?] = [
            "0": ["1": "one", "2": "two", "3": "three"] as? AnyCodable,
            "1": ["4": "four", "5": "five", "6": "six"] as? AnyCodable,
            "2": ["7": "seven", "8": "eight", "9": "nine"] as? AnyCodable
        ]

        client.dictionary.put(dictionaryValid: dictDict) { result, httpResponse in
            switch result {
            case .success:
                // FIXME: Cannot serialize the values as AnyCodable...
                self.client.dictionary.getDictionaryValid { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, dictDict)
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

    func test_getComplexItem_nullAndEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let testDictNull = ["0": testDict["0"], "1": nil, "2": testDict["2"]]

        client.dictionary.getComplexItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, testDictNull)

                let testDictEmpty = ["0": self.testDict["0"], "1": Widget(), "2": self.testDict["2"]]
                self.client.dictionary.getComplexItemEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, testDictEmpty)
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

    func test_getArray_empty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.dictionary.getArrayNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)

                self.client.dictionary.getArrayEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, [String: [String]]())
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

    func test_getArrayItem_nullAndEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let listDict = [
            "0": ["1", "2", "3"],
            "1": nil,
            "2": ["7", "8", "9"]
        ]

        // FIXME: Nil list is serialized as empty list instead...
        client.dictionary.getArrayItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, listDict)
                self.client.dictionary.getArrayItemEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, listDict)
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

    func test_dictionary_nullAndEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        // FIME: Data cannot be decoding due to wrong format.
        client.dictionary.getDictionaryNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)

                self.client.dictionary.getDictionaryEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, [String: AnyCodable]())
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

    func test_dictionaryItem_nullAndEmpty() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let dictDictNull: [String: AnyCodable?] = [
            "0": ["1": "one", "2": "two", "3": "three"] as? AnyCodable,
            "1": nil,
            "2": ["7": "seven", "8": "eight", "9": "nine"] as? AnyCodable
        ]

        let dictDictEmpty: [String: AnyCodable?] = [
            "0": ["1": "one", "2": "two", "3": "three"] as? AnyCodable,
            "1": [String: AnyCodable?]() as? AnyCodable,
            "2": ["7": "seven", "8": "eight", "9": "nine"] as? AnyCodable
        ]

        // FIXME: Cannot serialize to AnyCodable...
        client.dictionary.getDictionaryItemNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, dictDictNull)

                // FIXME: Cannot serialize to AnyCodable...
                self.client.dictionary.getDictionaryItemEmpty { result, httpResponse in
                    switch result {
                    case let .success(data):
                        XCTAssertEqual(data, dictDictEmpty)
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
}
