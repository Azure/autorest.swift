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
import AutoRestUrlTest

class AutoRestUrlTest: XCTestCase {
    var client: AutoRestUrlTestClient!
    
    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        
        client = try AutoRestUrlTestClient(globalStringPath: "",
                                           baseUrl: baseUrl,
                                           authPolicy: AnonymousAccessPolicy(),
                                           withOptions: AutoRestUrlTestClientOptions())
    }

    func test_Paths_byteNull200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteNull succeed")
        let failedExpectation = XCTestExpectation(description: "Call paths.byteNull failed")
        failedExpectation.isInverted = true
        
        client.paths.byteNull(bytePath: Data()) { result, _  in
            switch result {
                case .success:
                    failedExpectation.fulfill()
                case .failure:
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Paths_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call byteEmpty succeed")
        let failedExpectation = XCTestExpectation(description: "Call byteEmpty failed")
        failedExpectation.isInverted = true
        
        client.paths.byteEmpty() { result, httpResponse  in
            switch result {
                case .success:
                    expectation.fulfill()
                case .failure:
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Paths_byteMultiByte200() throws {
        let expectation = XCTestExpectation(description: "Call byteMultiByte succeed")
        let failedExpectation = XCTestExpectation(description: "Call byteMultiByte failed")
        failedExpectation.isInverted = true
        
        guard let byptePath = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8) else {
            return
        }
        client.paths.byteMultiByte(bytePath: byptePath) { result, httpResponse  in
            switch result {
                case .success:
                    expectation.fulfill()
                case .failure:
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanTrue200() throws {
        let expectation = XCTestExpectation(description: "Call getBooleanTrue succeed")
        let failedExpectation = XCTestExpectation(description: "Call getBooleanTrue failed")
        failedExpectation.isInverted = true
        
        client.paths.getBooleanTrue() { result, _  in
            switch result {
                case .success:
                    expectation.fulfill()
                case let .failure(error):
                    print("test failed. error=\(error.message)")
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
