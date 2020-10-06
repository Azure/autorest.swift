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
            baseUrl: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: XmsErrorResponseExtensionsClientOptions()
        )
    }

    func test_XmsErrorResponseExtensions_getPetById200() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with tommy succeed")

        client.petoperation.getPetById(petId: "tommy") { result, httpResponse in
            switch result {
            case let .success(data):
                if let pet = data {
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                    XCTAssertEqual(pet.name, "Tommy Tomson")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getPetById with tommy failed")
                }
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getPetById with tommy failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById202() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with django succeed")

        client.petoperation.getPetById(petId: "django") { result, httpResponse in
            switch result {
            case let .success(data):
                if (data as? Pet) != nil {
                    XCTFail("Call getPetById with django failed")
                } else {
                    XCTAssertEqual(httpResponse?.statusCode, 202)
                    expectation.fulfill()
                }
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getPetById with django failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById404_1() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with coyoteUgly succeed")

        client.petoperation.getPetById(petId: "coyoteUgly") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with coyoteUgly failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 404)
                if case let .service(_, innerError) = error,
                    let notFoundErrorBase = innerError as? NotFoundErrorBase {
                    XCTAssertEqual(notFoundErrorBase.reason, "the type of animal requested is not available")
                    XCTAssertEqual(notFoundErrorBase.whatNotFound, "AnimalNotFound")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getPetById with coyoteUgly failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById404_2() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with weirdAlYankovic succeed")

        client.petoperation.getPetById(petId: "weirdAlYankovic") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with weirdAlYankovic failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 404)
                if case let .service(_, innerError) = error,
                    let notFoundErrorBase = innerError as? NotFoundErrorBase {
                    XCTAssertEqual(notFoundErrorBase.reason, "link to pet not found")
                    XCTAssertEqual(notFoundErrorBase.whatNotFound, "InvalidResourceLink")
                    expectation.fulfill()
                } else {
                    XCTFail("Call getPetById with weirdAlYankovic failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById501() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with alien123 succeed")

        client.petoperation.getPetById(petId: "alien123") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with alien123 failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 501)
                if case let .service(_, innerError) = error,
                    let errorNo = innerError as? Int32 {
                    XCTAssertEqual(errorNo, 123)
                    expectation.fulfill()
                } else {
                    XCTFail("Call getPetById with alien123 failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_getPetById400() throws {
        let expectation = XCTestExpectation(description: "Call getPetById with ringo succeed")

        client.petoperation.getPetById(petId: "ringo") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call getPetById with ringo failed")

            case let .failure(error):
                XCTAssertEqual(httpResponse?.statusCode, 400)
                if case let .service(_, innerError) = error,
                    let errorString = innerError as? String {
                    XCTAssert(errorString.contains("ringo is missing"))
                    expectation.fulfill()
                } else {
                    XCTFail("Call getPetById with ringo failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething200() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with stay succeed")

        client.petoperation.doSomething(whatAction: "stay") { result, httpResponse in
            switch result {
            case let .success(petAction):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertNil(petAction.actionResponse)
                expectation.fulfill()

            case .failure:
                XCTFail("Call doSomething with stay failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething500() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with jump succeed")

        client.petoperation.doSomething(whatAction: "jump") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call doSomething with jump failed")

            case let .failure(error):
                if case let .service(_, innerError) = error,
                    let patActionError = innerError as? PetActionError {
                    XCTAssertEqual(httpResponse?.statusCode, 500)
                    XCTAssertEqual(patActionError.errorType, "PetSadError")
                    XCTAssertEqual(patActionError.errorMessage, "casper aint happy")
                    expectation.fulfill()
                } else {
                    XCTFail("Call doSomething with jump failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_XmsErrorResponseExtensions_doSomething404() throws {
        let expectation = XCTestExpectation(description: "Call doSomething with fetch succeed")

        client.petoperation.doSomething(whatAction: "fetch") { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call doSomething with fetch failed")

            case let .failure(error):
                if case let .service(_, innerError) = error,
                    let patActionError = innerError as? PetActionError {
                    XCTAssertEqual(httpResponse?.statusCode, 404)
                    XCTAssertEqual(patActionError.errorType, "PetHungryOrThirstyError")
                    XCTAssertEqual(patActionError.errorMessage, "scooby is low")
                    expectation.fulfill()
                } else {
                    XCTFail("Call doSomething with fetch failed")
                }
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
