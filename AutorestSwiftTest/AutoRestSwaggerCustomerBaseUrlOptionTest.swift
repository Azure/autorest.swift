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

import AutoRestParameterizedCustomHostTest
import AzureCore
import XCTest

class AutoRestParameterizedCustomHostTest: XCTestCase {
    var client: AutoRestParameterizedCustomHostTestClient!

    override func setUpWithError() throws {
        guard let endpoint = URL(string: "http://local") else {
            fatalError("Can't creat a base URL")
        }
        client = try AutoRestParameterizedCustomHostTestClient(
            subscriptionId: "test12",
            dnsSuffix: "host:3000",
            endpoint: endpoint,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestParameterizedCustomHostTestClientOptions()
        )
    }

    func test_getEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getEmpty")

        let options = GetEmptyOptions(
            keyVersion: "v1"
        )

        client.paths.getEmpty(
            vault: "http://lo",
            secret: "cal",
            keyName: "key1",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
