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

import Foundation
import XCTest
import AzureCore
import AutoRestSwaggerBatFile

class AutoRestSwaggerBatFileTest: XCTestCase {
    var client: AutoRestSwaggerBatFileClient!
    
    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        
        client = try AutoRestSwaggerBatFileClient(baseUrl: baseUrl,
                                            authPolicy: AnonymousAccessPolicy(),
                                            withOptions: AutoRestSwaggerBatFileClientOptions())
    }

    func test_BodyFile_getFile() throws {
        let expectation = XCTestExpectation(description: "Call getFile")
        let failedExpectation = XCTestExpectation(description: "Call getFile failed")
        failedExpectation.isInverted = true
        
        client.getFile() { result, httpResponse  in
            switch result {
                case .success:
                    guard let data = httpResponse?.data else {
                        failedExpectation.fulfill()
                        return
                    }
                    XCTAssertEqual(data.count, 8725)
                    expectation.fulfill()
               case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_BodyFile_getEmptyFile() throws {
           let expectation = XCTestExpectation(description: "Call getEmptyFile")
           let failedExpectation = XCTestExpectation(description: "Call getEmptyFile failed")
           failedExpectation.isInverted = true
           
        client.getEmptyFile() { result, httpResponse  in
               switch result {
                   case .success:
                       guard let data = httpResponse?.data else {
                           failedExpectation.fulfill()
                           return
                       }
                       XCTAssertTrue(data.isEmpty)
                       expectation.fulfill()
                  case let .failure(error):
                   print("test failed. error=\(error.message)")
                   failedExpectation.fulfill()
               }
           }
           
           wait(for: [expectation], timeout: 10.0)
       }
    
    func test_BodyFile_getFileLarge() throws {
           let expectation = XCTestExpectation(description: "Call getFileLarge")
           let failedExpectation = XCTestExpectation(description: "Call getFileLarge failed")
           failedExpectation.isInverted = true
           
        client.getFileLarge() { result, httpResponse  in
               switch result {
                   case .success:
                       guard let data = httpResponse?.data else {
                           failedExpectation.fulfill()
                           return
                       }
                       XCTAssertEqual(data.count, 3000 * 1024 * 1024)
                       expectation.fulfill()
                  case let .failure(error):
                   print("test failed. error=\(error.message)")
                   failedExpectation.fulfill()
               }
           }
           
           wait(for: [expectation], timeout: 10.0)
       }
}
