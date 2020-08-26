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
import AutoRestHeadTest

class AutoRestHeadTest: XCTestCase {
    var client: AutoRestHeadTestClient!
    
    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        
        client = try AutoRestHeadTestClient(baseUrl: baseUrl,
                                            authPolicy: AnonymousAccessPolicy(),
                                            withOptions: AutoRestHeadTestClientOptions())
    }

    func testhead200() throws {
        let expectation = XCTestExpectation(description: "Call head200")
        let failedExpectation = XCTestExpectation(description: "Call head200 failed")
        failedExpectation.isInverted = true
        
        client.head200() { result, _  in
            switch result {
                case .success:
                 expectation.fulfill()
               case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testhead204() throws {
        let expectation = XCTestExpectation(description: "Call head200")
        let failedExpectation = XCTestExpectation(description: "Call head200 failed")
        failedExpectation.isInverted = true
        
        client.head204() { result, _  in
            switch result {
                case .success:
                 expectation.fulfill()
               case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testhead404() throws {
        let expectation = XCTestExpectation(description: "Call head200")
        let failedExpectation = XCTestExpectation(description: "Call head200 failed")
        failedExpectation.isInverted = true
        
        client.head200() { result, _  in
            switch result {
                case .success:
                 expectation.fulfill()
               case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }
        
        // Wait until the expectation is fulfilled, with a timeout of 5 seconds.
        wait(for: [expectation], timeout: 5.0)
    }
}
