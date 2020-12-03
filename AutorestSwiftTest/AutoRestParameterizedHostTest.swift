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

import AutoRestParameterizedHostTest
import AzureCore
import XCTest

class AutoRestParameterizedHostTest: XCTestCase {
    var client: AutoRestParameterizedHostTestClient!

    override func setUpWithError() throws {
        guard let endpoint = URL(string: "http://wronghost") else {
            fatalError("Can't creat a base URL")
        }
        client = try AutoRestParameterizedHostTestClient(
            host: "host:3000",
            endpoint: endpoint,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestParameterizedHostTestClientOptions()
        )
    }

    func test_get_empty200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getEmpty")

        client.paths.getEmpty(accountName: "local") { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.getEmpty failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_get_emptyFailed() throws {
        let expectation = XCTestExpectation(description: "Call paths.getEmpty")

        client.paths.getEmpty(accountName: "bad") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call paths.getEmptyFailed should failed")
            case .failure:
                XCTAssertNil(httpResponse?.statusCode)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
