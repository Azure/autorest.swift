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
// import AutoRestSwaggerBatByte
// import AzureCore
// import XCTest
//
// class AutoRestSwaggerBatByteTest: XCTestCase {
//    var client: AutoRestSwaggerBatByteClient!
//
//    override func setUpWithError() throws {
//        client = try AutoRestSwaggerBatByteClient(
//            authPolicy: AnonymousAccessPolicy(),
//            withOptions: AutoRestSwaggerBatByteClientOptions()
//        )
//    }
//
//    func test_getnull200() throws {
//        let expectation = XCTestExpectation(description: "Call byte.getNull")
//
//        client.byte.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data.count, 0)
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
//    func test_getEmpty200() throws {
//        let expectation = XCTestExpectation(description: "Call byte.getEmpty")
//
//        client.byte.getEmpty { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(String(decoding: data, as: UTF8.self), "\"\"")
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getEmpty failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getNonAscii200() throws {
//        let expectation = XCTestExpectation(description: "Call byte.getNonAscii")
//
//        client.byte.getNonAscii { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(String(decoding: data, as: UTF8.self), "\"//79/Pv6+fj39g==\"")
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getNonAscii failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getInvalid() throws {
//        let expectation = XCTestExpectation(description: "Call byte.getInvalid")
//
//        client.byte.getInvalid { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(String(decoding: data, as: UTF8.self), "\"::::SWAGGER::::\"")
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call getInvalid failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putInvalid() throws {
//        let expectation = XCTestExpectation(description: "Call byte.put")
//
//        client.byte.put(nonAscii: "\"//79/Pv6+fj39g==\"".data(using: .utf8) ?? Data()) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call put failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
// }
