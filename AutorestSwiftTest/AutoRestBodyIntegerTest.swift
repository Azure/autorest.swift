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

import XCTest
import AzureCore
import AutoRestIntegerTest

class AutoRestIntegerTest: XCTestCase {
    var client: AutoRestIntegerTestClient!
    
    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        
        client = try AutoRestIntegerTestClient(baseUrl: baseUrl,
                                            authPolicy: AnonymousAccessPolicy(),
                                            withOptions: AutoRestIntegerTestClientOptions())
    }

    func Atest_BodyInteger_getNull200() throws {
        let expectation = XCTestExpectation(description: "Call getNull succeed")
        let failedExpectation = XCTestExpectation(description: "Call getNull failed")
        failedExpectation.isInverted = true
        
        
        client.getNull() { result, httpResponse  in
            switch result {
                case .success:
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                    expectation.fulfill()
               case let .failure(error):
                    print("test failed. error=\(error.message)")
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
 
    func Btest_BodyInteger_getInvalid200() throws {
        let expectation = XCTestExpectation(description: "Call getInvalid succeed")
        let failedExpectation = XCTestExpectation(description: "Call getInvalid failed")
        failedExpectation.isInverted = true
        
        
        client.getInvalid() { result, httpResponse  in
            switch result {
                case .success:
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                    expectation.fulfill()
               case let .failure(error):
                    print("test failed. error=\(error.message)")
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
}
