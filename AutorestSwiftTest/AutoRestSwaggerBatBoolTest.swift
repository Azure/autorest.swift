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
// import AutoRestBoolTest
// import AzureCore
// import XCTest
//
// class AutoRestSwaggerBatBoolTest: XCTestCase {
//    var client: AutoRestBoolTestClient!
//
//    override func setUpWithError() throws {
//        client = try AutoRestBoolTestClient(
//            authPolicy: AnonymousAccessPolicy(),
//            withOptions: AutoRestBoolTestClientOptions()
//        )
//    }
//
//    func test_getTrue200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.getTrue")
//
//        client.boolOperation.getTrue { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, true)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call bool.getTrue failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putTrue200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.putTrue")
//
//        client.boolOperation.putTrue { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call bool.putTrue failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getFalse200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.getFalse")
//
//        client.boolOperation.getFalse { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, false)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call bool.getFalse failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putFalse200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.putFalse")
//
//        client.boolOperation.putFalse { result, httpResponse in
//            switch result {
//            case .success:
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
//    func test_getNull200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.getNull")
//
//        client.boolOperation.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertNil(data)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call bool.getNull failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getInvalid200() throws {
//        let expectation = XCTestExpectation(description: "Call bool.getInvalid")
//
//        client.boolOperation.getInvalid { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("bool.getInvalid expected failed")
//            case .failure:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
// }
