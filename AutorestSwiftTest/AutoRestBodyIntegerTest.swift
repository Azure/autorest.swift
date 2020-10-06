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

import AutoRestIntegerTest
import AzureCore
import XCTest

class AutoRestIntegerTest: XCTestCase {
    var client: AutoRestIntegerTestClient!

    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }

        client = try AutoRestIntegerTestClient(
            baseUrl: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestIntegerTestClientOptions()
        )
    }

    func test_BodyInteger_getNull200() throws {
        let expectation = XCTestExpectation(description: "Call getNull succeed")

        client.inttype.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, nil)
                XCTAssertEqual(httpResponse?.statusCode, 200)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getInvalid200() throws {
        let expectation = XCTestExpectation(description: "Call getInvalid succeed")

        client.inttype.getInvalid { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getInvalid failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "123jkl")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getInvalid failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getOverflowInt32_200() throws {
        let expectation = XCTestExpectation(description: "Call getOverflowInt32 succeed")

        client.inttype.getOverflowInt32 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getOverflowInt32 failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "2147483656")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getOverflowInt32 failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getUnderflowInt32_200() throws {
        let expectation = XCTestExpectation(description: "Call getOverflowInt32 succeed")

        client.inttype.getUnderflowInt32 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getOverflowInt32 failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "-2147483656")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getOverflowInt32 failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getOverflowInt64_200() throws {
        let expectation = XCTestExpectation(description: "Call getOverflowInt32 succeed")

        client.inttype.getOverflowInt64 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getOverflowInt32 failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "9223372036854775910")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getOverflowInt32 failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getUnderflowInt64_200() throws {
        let expectation = XCTestExpectation(description: "Call getOverflowInt32 succeed")

        client.inttype.getUnderflowInt64 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getOverflowInt32 failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "-9223372036854775910")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getOverflowInt32 failed")
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getUnixTime_200() throws {
        let expectation = XCTestExpectation(description: "Call getUnixTime succeed")

        client.inttype.getUnixTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                let expectedDate = ISO8601DateFormatter().date(from: "2016-04-13T00:00:00Z")
                XCTAssertEqual(expectedDate, data)
                expectation.fulfill()
            case .failure:
                XCTFail("Call getUnixTime failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getInvalidUnixTime_200() throws {
        let expectation = XCTestExpectation(description: "Call getInvalidUnixTime succeed")

        client.inttype.getInvalidUnixTime { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getInvalidUnixTime failed")
            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssert(error.message.contains("Decoding error."))
                if let data = httpResponse?.data,
                    let dataStr = String(data: data, encoding: .utf8) {
                    XCTAssert(dataStr == "123jkl")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getInvalidUnixTime failed")
                }
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_BodyInteger_getNullUnixTime_200() throws {
        let expectation = XCTestExpectation(description: "Call getOverflowInt32 succeed")

        client.inttype.getNullUnixTime { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, nil)
                XCTAssertEqual(httpResponse?.statusCode, 200)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getOverflowInt32 failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
