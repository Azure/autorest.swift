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

import AutoRestHttpInfrastructureTest
import AzureCore
import XCTest

class AutoRestHttpInfrastructureTest: XCTestCase {
    var client: AutoRestHttpInfrastructureTestClient!

    override func setUpWithError() throws {
        client = try AutoRestHttpInfrastructureTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestHttpInfrastructureTestClientOptions()
        )
    }

//    func test_get200_model204() throws {
//        let expectation = XCTestExpectation(description: "Call \(#function)")
//
//        client.multipleResponses.get200Model204NoModelDefaultError200Valid { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("Call \(#function) failed. error=\(details)")
//            }
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5.0)
//    }

    func test_serverError_statusCodes_head501() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.httpServerFailure.head501 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("501"), "Error: \(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_serverError_statusCodes_get501() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.httpServerFailure.get501 { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("501"), "Error: \(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
