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
// import AutoRestRfC1123DateTimeTest
// import AzureCore
// import XCTest
//
// class AutoRestRfC1123DateTimeTest: XCTestCase {
//    var client: AutoRestRfC1123DateTimeTestClient!
//
//    override func setUpWithError() throws {
//        client = try AutoRestRfC1123DateTimeTestClient(
//            authPolicy: AnonymousAccessPolicy(),
//            withOptions: AutoRestRfC1123DateTimeTestClientOptions()
//        )
//    }
//
//    func test_getNull200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getNull")
//
//        client.datetimerfc1123.getNull { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertNil(data)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.getNull failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getInvalidDate200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getInvalid")
//
//        client.datetimerfc1123.getInvalid { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("date.getInvalid expected failed")
//            case .failure:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getOverflow200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getOverflow")
//
//        client.datetimerfc1123.getOverflow { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.getOverflow failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getUnderflow200() throws {
//        let expectation = XCTestExpectation(description: "Call date.getUnderflow")
//
//        client.datetimerfc1123.getUnderflow { result, httpResponse in
//            switch result {
//            case .success:
//                XCTFail("date.getUnderflowDate expected failed")
//            case .failure:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putMaxDate200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.putMaxDate")
//
//        guard let date = Date.Format.rfc1123.formatter.date(from: "Fri, 31 Dec 9999 23:59:59 GMT") else {
//            XCTFail("Input is not a datetime")
//            return
//        }
//
//        client.datetimerfc1123.put(utcMaxDateTime: date) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call date.putMaxDate failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getUtcUppercaseMaxDateTime200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getUtcUppercaseMaxDateTime")
//
//        let iso8601DateFormatter = ISO8601DateFormatter()
//        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//        guard let expectedDate = Date.Format.rfc1123.formatter.date(from: "Fri, 31 Dec 9999 23:59:59 GMT") else {
//            XCTFail("Input is not a datetime")
//            return
//        }
//
//        client.datetimerfc1123.getUtcUppercaseMaxDateTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, expectedDate)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.getUtcUppercaseMaxDateTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_putUtcMinDate200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.putUtcMinDate")
//
//        guard let date = Date.Format.rfc1123.formatter.date(from: "Mon, 01 Jan 0001 00:00:00 GMT") else {
//            XCTFail("Input is not a datetime")
//            return
//        }
//        client.datetimerfc1123.put(utcMinDateTime: date) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.putUtcMinDate failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getUtcMinDateTime200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getUtcMinDateTime")
//
//        guard let expectedDate = Date.Format.rfc1123.formatter.date(from: "Mon, 01 Jan 0001 00:00:00 GMT") else {
//            XCTFail("Input is not a datetime")
//            return
//        }
//
//        client.datetimerfc1123.getUtcMinDateTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, expectedDate)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.getUtcMinDateTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
//
//    func test_getUtcLowercaseMaxDateTime200() throws {
//        let expectation = XCTestExpectation(description: "Call datetimerfc1123.getUtcLowercaseMaxDateTime")
//
//        guard let expectedDate = Date.Format.rfc1123.formatter.date(from: "fri, 31 dec 9999 23:59:59 gmt".capitalized)
//        else {
//            XCTFail("Input is not a datetime")
//            return
//        }
//
//        client.datetimerfc1123.getUtcLowercaseMaxDateTime { result, httpResponse in
//            switch result {
//            case let .success(data):
//                XCTAssertEqual(data, expectedDate)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call datetimerfc1123.getUtcLowercaseMaxDateTime failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
// }
