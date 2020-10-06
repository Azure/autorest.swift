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
        
        client.paths.byteNull(bytePath: Data()) { result, _ in
            switch result {
                case .success:
                    failedExpectation.fulfill()
                case .failure:
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Paths_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteEmpty succeed")
        let failedExpectation = XCTestExpectation(description: "Call paths.byteEmpty failed")
        failedExpectation.isInverted = true
        
        client.paths.byteEmpty() { result, _  in
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
        let expectation = XCTestExpectation(description: "Call paths.byteMultiByte succeed")
        let failedExpectation = XCTestExpectation(description: "Call paths.byteMultiByte failed")
        failedExpectation.isInverted = true
        
        guard let bytePath = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8) else {
            return
        }
        client.paths.byteMultiByte(bytePath: bytePath) { result, _  in
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
        let expectation = XCTestExpectation(description: "Call paths.getBooleanTrue succeed")
        let failedExpectation = XCTestExpectation(description: "Call paths.getBooleanTrue failed")
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
    
    func test_Paths_getBooleanFalse200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanFalse succeed")
        let failedExpectation = XCTestExpectation(description: "Call paths.getBooleanFalse failed")
        failedExpectation.isInverted = true
        
        client.paths.getBooleanFalse() { result, _  in
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
    
    func test_Queries_byteNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteNull succeed")
        let failedExpectation = XCTestExpectation(description: "Call queries.byteNull failed")
        failedExpectation.isInverted = true
        
        let options = Queries.ByteNullOptions(byteQuery: Data())
        client.queries.byteNull(withOptions: options) { result, _ in
            switch result {
                case .success:
                    failedExpectation.fulfill()
                case .failure:
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteEmpty succeed")
        let failedExpectation = XCTestExpectation(description: "Call queries.byteEmpty failed")
        failedExpectation.isInverted = true
        
        client.queries.byteEmpty() { result, _  in
            switch result {
                case .success:
                    expectation.fulfill()
                case .failure:
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Queries_byteMultiByte200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteMultiByte succeed")
        let failedExpectation = XCTestExpectation(description: "Call queries.byteMultiByte failed")
        failedExpectation.isInverted = true
        
        guard let byteQuery = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8) else {
            return
        }
        let options = Queries.ByteMultiByteOptions(byteQuery: byteQuery)
        client.queries.byteMultiByte(withOptions: options) { result, httpResponse in
            switch result {
                case .success:
                    expectation.fulfill()
                case .failure:
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_Queries_getBooleanTrue200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanTrue succeed")
        let failedExpectation = XCTestExpectation(description: "Call queries.getBooleanTrue failed")
        failedExpectation.isInverted = true
        
        client.queries.getBooleanTrue() { result, _  in
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
    
    func test_Queries_getBooleanFalse200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanFalse succeed")
        let failedExpectation = XCTestExpectation(description: "Call queries.getBooleanFalse failed")
        failedExpectation.isInverted = true
        
        client.queries.getBooleanFalse() { result, _  in
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
