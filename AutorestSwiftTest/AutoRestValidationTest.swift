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

import AutoRestValidationTest
import AzureCore
import XCTest

// swiftlint:disable force_try
class AutoRestValidationTest: XCTestCase {
    private func getClient(apiVersion: AutoRestValidationTestClient.ApiVersion? = nil) -> AutoRestValidationTestClient {
        let options = AutoRestValidationTestClientOptions(apiVersion: apiVersion ?? .custom("12-34-5678"))
        return try! AutoRestValidationTestClient(
            subscriptionId: "abc123", url: URL(string: "http://localhost:3000")!,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: options
        )
    }

    private func getBody(displayNames: [String]? = nil, capacity: Int32? = nil) -> Product {
        return Product(
            displayNames: displayNames,
            capacity: capacity,
            image: nil,
            child: ChildProduct(),
            constChild: ConstantProduct()
        )
    }

    func test_get_withConstantInPath() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest.getWithConstantInPath { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_post_withConstantInBody() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        let constantBody = getBody()
        client.autoRestValidationTest.post(withConstantInBody: constantBody) { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_minLengthValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "1", id: 100) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: minLength 3"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_maxLengthValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "1234567890A", id: 100) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: maxLength 10"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_patternValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "!@#$", id: 100) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: pattern"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_multipleValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "123", id: 105) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("id: multipleOf 10"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_minimumValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "123", id: 0) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("id: minimum 100"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_maxmimumValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "123", id: 2000) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("id: maximum 1000"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_minimumExValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        let constantBody = getBody(capacity: 0)
        client.autoRestValidationTest
            .validation(ofBody: constantBody, resourceGroupName: "123", id: 150) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: BLOOT"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_maximumExValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        let constantBody = getBody(capacity: 100)
        client.autoRestValidationTest
            .validation(ofBody: constantBody, resourceGroupName: "123", id: 150) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: BLOOT"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_maxItemsValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient()
        let constantBody = getBody(displayNames: ["item1", "item2", "item3", "item4", "item5", "item6", "item7"])
        client.autoRestValidationTest
            .validation(ofBody: constantBody, resourceGroupName: "123", id: 150) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: BLOOT"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_apiVersionValidation() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let client = getClient(apiVersion: .custom("abc"))
        client.autoRestValidationTest
            .validationOfMethodParameters(resourceGroupName: "123", id: 150) { result, httpResponse in
                switch result {
                case .success:
                    XCTFail("Call \(#function) succeeded. Expected failure.")
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTAssert(details.contains("resourceGroupName: BLOOT"), "Error: \(details)")
                }
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 5.0)
    }
}
