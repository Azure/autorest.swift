//// --------------------------------------------------------------------------
////
//// Copyright (c) Microsoft Corporation. All rights reserved.
////
//// The MIT License (MIT)
////
//// Permission is hereby granted, free of charge, to any person obtaining a copy
//// of this software and associated documentation files (the ""Software""), to
//// deal in the Software without restriction, including without limitation the
//// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//// sell copies of the Software, and to permit persons to whom the Software is
//// furnished to do so, subject to the following conditions:
////
//// The above copyright notice and this permission notice shall be included in
//// all copies or substantial portions of the Software.
////
//// THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//// IN THE SOFTWARE.
////
//// --------------------------------------------------------------------------
//
// import AutoRestIntegerTest
// import AzureCore
// import XCTest
//
// class AutoRestIntegerTest: XCTestCase {
//    var client: AutoRestIntegerTestClient!
//
//    override func setUpWithError() throws {
//        client = try AutoRestIntegerTestClient(
//            authPolicy: AnonymousAccessPolicy(),
//            withOptions: AutoRestIntegerTestClientOptions()
//        )
//    }
//
//    func test_BodyInteger_getNull200() throws {
//        let expectation = XCTestExpectation(description: "Call getNull")
//
//        client.intOperation.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, nil)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getNull failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getInvalid200() throws {
//        let expectation = XCTestExpectation(description: "Call getInvalid")
//
//        client.intOperation.getInvalid { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getInvalid failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "123jkl")
//                } else {
//                    XCTFail("Call getInvalid failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getOverflowInt32_200() throws {
//        let expectation = XCTestExpectation(description: "Call getOverflowInt32")
//
//        client.intOperation.getOverflowInt32 { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getOverflowInt32 failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "2147483656")
//                } else {
//                    XCTFail("Call getOverflowInt32 failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getUnderflowInt32_200() throws {
//        let expectation = XCTestExpectation(description: "Call getOverflowInt32")
//
//        client.intOperation.getUnderflowInt32 { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getOverflowInt32 failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "-2147483656")
//
//                } else {
//                    XCTFail("Call getOverflowInt32 failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getOverflowInt64_200() throws {
//        let expectation = XCTestExpectation(description: "Call getOverflowInt64")
//
//        client.intOperation.getOverflowInt64 { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getOverflowInt64 failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "9223372036854775910")
//                    expectation.fulfill()
//                } else {
//                    XCTFail("Call getOverflowInt64 failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getUnderflowInt64_200() throws {
//        let expectation = XCTestExpectation(description: "Call getOverflowInt32")
//
//        client.intOperation.getUnderflowInt64 { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getOverflowInt32 failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "-9223372036854775910")
//                } else {
//                    XCTFail("Call getOverflowInt32 failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getUnixTime_200() throws {
//        let expectation = XCTestExpectation(description: "Call getUnixTime")
//
//        client.intOperation.getUnixTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//
//                let expectedDate = ISO8601DateFormatter().date(from: "2016-04-13T00:00:00Z")
//                XCTAssertEqual(expectedDate, data)
//            case .failure:
//                XCTFail("Call getUnixTime failed.")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getInvalidUnixTime_200() throws {
//        let expectation = XCTestExpectation(description: "Call getInvalidUnixTime")
//
//        client.intOperation.getInvalidUnixTime { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getInvalidUnixTime failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssert(error.message.contains("Decoding error."))
//                if let data = httpResponse?.data,
//                    let dataStr = String(data: data, encoding: .utf8) {
//                    XCTAssert(dataStr == "123jkl")
//                } else {
//                    XCTFail("Call getInvalidUnixTime failed.")
//                }
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_getNullUnixTime_200() throws {
//        let expectation = XCTestExpectation(description: "Call getNullUnixTime")
//
//        client.intOperation.getNullUnixTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, nil)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getNullUnixTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_putMax32_200() throws {
//        let expectation = XCTestExpectation(description: "Call putMax32")
//
//        client.intOperation.put(max32: Int32.max) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putMax32 failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_putMax64_200() throws {
//        let expectation = XCTestExpectation(description: "Call putMax64")
//
//        client.intOperation.put(max64: Int64.max) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putMax64 failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_putMin32_200() throws {
//        let expectation = XCTestExpectation(description: "Call putMin32")
//
//        client.intOperation.put(min32: Int32.min) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putMin32 failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_putMin64_200() throws {
//        let expectation = XCTestExpectation(description: "Call putMin64")
//
//        client.intOperation.put(min64: Int64.min) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                expectation.fulfill()
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putMax64 failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_BodyInteger_putUnixtime_200() throws {
//        let expectation = XCTestExpectation(description: "Call putUnixTime")
//
//        let decoded = Date(timeIntervalSince1970: Double(1_460_505_600))
//
//        client.intOperation.put(unixTimeDate: decoded) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putUnixTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
// }
