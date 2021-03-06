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

import AzureCore
import XCTest
import XmsErrorResponseExtensions

class XmsErrorResponseExtensionsTest: XCTestCase {
    var client: XmsErrorResponseExtensionsClient!

    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }

        client = try XmsErrorResponseExtensionsClient(
            url: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: XmsErrorResponseExtensionsClientOptions()
        )
    }

    func test_XmsErrorResponseExtensions_getPetById200() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with tommy")

        client.petOperation.getPetById(petId: "tommy") { result, httpResponse in
            switch result {
            case let .success(data):
                if let pet = data {
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                    XCTAssertEqual(pet.name, "Tommy Tomson")
                } else {
                    XCTFail("Call getPetById with tommy failed")
                }
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getPetById with tommy failed")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById202() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with django")

        client.petOperation.getPetById(petId: "django") { result, httpResponse in
            switch result {
            case let .success(data):
                if data != nil {
                    XCTFail("Call getPetById with django failed")
                } else {
                    XCTAssertEqual(httpResponse?.statusCode, 202)
                }
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getPetById with django failed")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById404_1() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with coyoteUgly")

        client.petOperation.getPetById(petId: "coyoteUgly") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with coyoteUgly failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 404)
                if case let .service(_, innerError) = error,
                    let notFoundErrorBase = innerError as? NotFoundErrorBase {
                    XCTAssertEqual(notFoundErrorBase.reason, "the type of animal requested is not available")
                    XCTAssertEqual(notFoundErrorBase.whatNotFound, "AnimalNotFound")
                } else {
                    XCTFail("Call getPetById with coyoteUgly failed")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById404_2() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with weirdAlYankovic")

        client.petOperation.getPetById(petId: "weirdAlYankovic") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with weirdAlYankovic failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 404)
                if case let .service(_, innerError) = error,
                    let notFoundErrorBase = innerError as? NotFoundErrorBase {
                    XCTAssertEqual(notFoundErrorBase.reason, "link to pet not found")
                    XCTAssertEqual(notFoundErrorBase.whatNotFound, "InvalidResourceLink")
                } else {
                    XCTFail("Call getPetById with weirdAlYankovic failed")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById501() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with alien123")

        client.petOperation.getPetById(petId: "alien123") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with alien123 failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 501)
                if case let .service(_, innerError) = error,
                    let errorNo = innerError as? Int32 {
                    XCTAssertEqual(errorNo, 123)
                } else {
                    XCTFail("Call getPetById with alien123 failed")
                }
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById400() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with ringo")

        client.petOperation.getPetById(petId: "ringo") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with ringo failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 400)
                if case let .service(_, innerError) = error,
                    let errorString = innerError as? String {
                    XCTAssert(errorString.contains("ringo is missing"))
                } else {
                    XCTFail("Call getPetById with ringo failed")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething200() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with stay")

        client.petOperation.doSomething(whatAction: "stay") { result, httpResponse in
            switch result {
            case let .success(petAction):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertNil(petAction.actionResponse)
            case .failure:
                XCTFail("Call doSomething with stay failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething500() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with jump")

        client.petOperation.doSomething(whatAction: "jump") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call doSomething with jump failed")

            case let .failure(error):
                if case let .service(_, innerError) = error,
                    let patActionError = innerError as? PetActionError {
                    XCTAssertEqual(httpResponse?.statusCode, 500)
                    XCTAssertEqual(patActionError.errorType, "PetSadError")
                    XCTAssertEqual(patActionError.errorMessage, "casper aint happy")
                } else {
                    XCTFail("Call doSomething with jump failed")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething404() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with fetch")

        client.petOperation.doSomething(whatAction: "fetch") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call doSomething with fetch failed")

            case let .failure(error):
                if case let .service(_, innerError) = error,
                    let patActionError = innerError as? PetActionError {
                    XCTAssertEqual(httpResponse?.statusCode, 404)
                    XCTAssertEqual(patActionError.errorType, "PetHungryOrThirstyError")
                    XCTAssertEqual(patActionError.errorMessage, "scooby is low")
                } else {
                    XCTFail("Call doSomething with fetch failed")
                }
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
