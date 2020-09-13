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
import XmsErrorResponseExtensions

class XmsErrorResponseExtensionsTest: XCTestCase {
    var client: XmsErrorResponseExtensionsClient!
    
    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }
        
        client = try XmsErrorResponseExtensionsClient(baseUrl: baseUrl,
                                            authPolicy: AnonymousAccessPolicy(),
                                            withOptions: XmsErrorResponseExtensionsClientOptions())
    }

    func test_XmsErrorResponseExtensions_getPetById200() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with tommy")
        let failedExpectation = XCTestExpectation(description: "Call getPetById with tommy failed")
        failedExpectation.isInverted = true
        
        client.getPetById(petId: "tommy") { result, httpResponse  in
            switch result {
                case let .success(data):
                    if let pet = data as? Pet {
                        XCTAssertEqual(httpResponse?.statusCode, 200)
                        XCTAssertEqual(pet.name, "Tommy Tomson")
                        expectation.fulfill()
                    } else {
                        failedExpectation.fulfill()
                    }
               case let .failure(error):
                    print("test failed. error=\(error.message)")
                    failedExpectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_XmsErrorResponseExtensions_getPetById202() throws {
           let expectation = XCTestExpectation(description: "Call getPetById with django")
           let failedExpectation = XCTestExpectation(description: "Call getPetById with django failed")
           failedExpectation.isInverted = true
           
           client.getPetById(petId: "django") { result, httpResponse  in
               switch result {
                   case let .success(data):
                    if ((data as? Pet) != nil) {
                            failedExpectation.fulfill()
                       } else {
                            XCTAssertEqual(httpResponse?.statusCode, 202)
                            expectation.fulfill()
                       }
                  case let .failure(error):
                       print("test failed. error=\(error.message)")
                       failedExpectation.fulfill()
               }
           }
           
           wait(for: [expectation], timeout: 5.0)
       }
    
    func test_XmsErrorResponseExtensions_getPetById404_1() throws {
            let expectation = XCTestExpectation(description: "Call getPetById with coyoteUgly")
            let failedExpectation = XCTestExpectation(description: "Call getPetById with coyoteUgly failed")
            failedExpectation.isInverted = true
            
            client.getPetById(petId: "coyoteUgly") { result, httpResponse  in
                switch result {
                    case .success:
                        print("test failed.")
                        failedExpectation.fulfill()

                   case let .failure(error):
                        XCTAssertEqual(httpResponse?.statusCode, 404)
                        expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
    }
    
    func test_XmsErrorResponseExtensions_getPetById404_2() throws {
            let expectation = XCTestExpectation(description: "Call getPetById with weirdAlYankovic")
            let failedExpectation = XCTestExpectation(description: "Call getPetById with weirdAlYankovic failed")
            failedExpectation.isInverted = true
            
            client.getPetById(petId: "weirdAlYankovic") { result, httpResponse  in
                switch result {
                    case .success:
                        print("test failed.")
                        failedExpectation.fulfill()

                   case let .failure(error):
                        XCTAssertEqual(httpResponse?.statusCode, 404)
                        expectation.fulfill()
                }
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
    
    func test_XmsErrorResponseExtensions_getPetById501() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with alien123")
        let failedExpectation = XCTestExpectation(description: "Call getPetById with alien123 failed")
        failedExpectation.isInverted = true
        
        client.getPetById(petId: "alien123") { result, httpResponse  in
            switch result {
                case .success:
                    print("test failed.")
                    failedExpectation.fulfill()

               case let .failure(error):
                    XCTAssertEqual(httpResponse?.statusCode, 501)
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
