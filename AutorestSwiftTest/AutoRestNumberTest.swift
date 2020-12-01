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
// import AutoRestNumberTest
// import AzureCore
// import XCTest
//
// class AutoRestNumberTest: XCTestCase {
//    var client: AutoRestNumberTestClient!
//
//    override func setUpWithError() throws {
//        client = try AutoRestNumberTestClient(
//            authPolicy: AnonymousAccessPolicy(),
//            withOptions: AutoRestNumberTestClientOptions()
//        )
//    }
//
//    func test_getnull200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getNull")
//
//        client.number.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertNil(data)
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
//    func test_getInvalidFloat200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getInvalidFloat")
//
//        client.number.getInvalidFloat { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getInvalidFloat should failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTAssertTrue(error.message.contains("Decoding error."))
//                XCTAssertEqual(details, "2147483656.090096789909j")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getInvalidDouble200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getInvalidDouble")
//
//        client.number.getInvalidDouble { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getInvalidDouble should failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTAssertTrue(error.message.contains("Decoding error."))
//                XCTAssertEqual(details, "9223372036854775910.980089k")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getInvalidDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getInvalidDecimal")
//
//        client.number.getInvalidDecimal { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("Call getInvalidDouble should failed.")
//            case let .failure(error):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTAssertTrue(error.message.contains("Decoding error."))
//                XCTAssertEqual(details, "9223372036854775910.980089k")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putBigDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putBigDecimal")
//
//        client.number.put(bigDecimal: Decimal(2.5976931e+101)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getBigDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDecimal")
//
//        client.number.getBigDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Decimal(2.5976931e+101))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    // Need to add support to encode Decimal constant into String before we can enable this test case
//    /*
//     func test_putBigDecimalPositiveDecimal200() throws {
//         let expectation = XCTestExpectation(description: "Call number.putBigDecimalPositiveDecimal")
//
//         client.number.putBigDecimalPositiveDecimal { result, httpResponse in
//             switch result {
//             case .success:
//                 XCTAssertEqual(httpResponse?.statusCode, 200)
//             case let .failure(error):
//                 let details = errorDetails(for: error, withResponse: httpResponse)
//                 XCTFail("Call putBigDecimalPositiveDecimal failed. error=\(details)")
//             }
//             expectation.fulfill()
//         }
//         wait(for: [expectation], timeout: 5.0)
//     }
//     */
//
//    func test_getBigDecimalPositiveDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDecimalPositiveDecimal")
//
//        client.number.getBigDecimalPositiveDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Decimal(99_999_999.99))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    // Need to add support to encode Decimal constant into String before we can enable this test case
//    /*
//     func test_putBigDecimalNegativeDecimal200() throws {
//         let expectation = XCTestExpectation(description: "Call number.putBigDecimalNegativeDecimal")
//
//         client.number.putBigDecimalNegativeDecimal { result, httpResponse in
//             switch result {
//             case .success:
//                 XCTAssertEqual(httpResponse?.statusCode, 200)
//             case let .failure(error):
//                 let details = errorDetails(for: error, withResponse: httpResponse)
//                 XCTFail("Call putBigDecimal failed. error=\(details)")
//             }
//             expectation.fulfill()
//         }
//         wait(for: [expectation], timeout: 5.0)
//     }
//     */
//
//    func test_getBigDecimalNegativeDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDecimalPositiveDecimal")
//
//        client.number.getBigDecimalNegativeDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Decimal(-99_999_999.99))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getBigDecimalPositiveDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putSmallFloat200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putSmallFloat")
//
//        client.number.put(smallFloat: Float(3.402823e-20)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putSmallFloat failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getSmallFloat200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getSmallFloat")
//
//        client.number.getSmallFloat { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Double(3.402823e-20))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getSmallFloat failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putSmallDouble200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putSsmallDouble")
//
//        client.number.put(smallDouble: Double(2.5976931e-101)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putSsmallDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getSmallDouble200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getSmallDouble")
//
//        client.number.getSmallDouble { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Double(2.5976931e-101))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getSmallDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putSmallDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putSmallDecimal")
//
//        client.number.put(smallDecimal: Decimal(2.5976931e-101)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putSmallDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getSmallDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getSmallDecimal")
//
//        client.number.getSmallDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Decimal(2.5976931e-101))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getSmallDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putBigDouble200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putBigDouble")
//
//        client.number.put(bigDouble: Double(2.5976931e+101)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getBigDouble200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDouble")
//
//        client.number.getBigDouble { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Double(2.5976931e+101))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getBigDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putBigDoublePositiveDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.BigDoublePositiveDecimal")
//
//        client.number.putBigDoublePositiveDecimal { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getBigDoublePositiveDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDoublePositiveDecimal")
//
//        client.number.getBigDoublePositiveDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Double(99_999_999.99))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getBigDouble failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putDoubleBigNegativeDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.putBigDoubleNegativeDecimal")
//
//        client.number.putBigDoubleNegativeDecimal { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call putBigDoubleNegativeDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getDoubleBigNegativeDecimal200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigDoubleNegativeDecimal")
//
//        client.number.getBigDoubleNegativeDecimal { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Double(-99_999_999.99))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getBigDoubleNegativeDecimal failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_bigFloat200() throws {
//        let expectation = XCTestExpectation(description: "Call number.bigFloat")
//
//        client.number.put(bigFloat: Float(3.402823e+20)) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(expectation.description) failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getBigFloat200() throws {
//        let expectation = XCTestExpectation(description: "Call number.getBigFloat")
//
//        client.number.getBigFloat { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(data, Float(3.402823e+20))
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getBigFloat failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
// }
