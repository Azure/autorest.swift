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

import AutoRestRequiredOptionalTest
import AzureCore
import XCTest

class AutoRestRequiredOptionalTest: XCTestCase {
    var client: AutoRestRequiredOptionalTestClient!

    override func setUpWithError() throws {
        client = try AutoRestRequiredOptionalTestClient(
            requiredGlobalPath: "required_path",
            requiredGlobalQuery: "required_query",
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestRequiredOptionalTestClientOptions()
        )
    }

    func test_implicit_putOptionalQuery200() throws {
        let expectation = XCTestExpectation(description: "Call implicit.putOptionalQuery")

        client.implicit.putOptionalQuery { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_implicit_putOptionalBody200() throws {
        let expectation = XCTestExpectation(description: "Call implicit.putOptionalBody")

        client.implicit.put(optionalBody: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_implicit_getOptionalGlobalQuery200() throws {
        let expectation = XCTestExpectation(description: "Call implicit.getOptionalGlobalQuery")

        client.implicit.getOptionalGlobalQuery { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalIntegerParameter200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalIntegerParameter")

        client.explicit.post(optionalIntegerParameter: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalIntegerHeader200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalIntegerHeader")

        client.explicit.postOptionalIntegerHeader { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalStringParameter200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalStringParameter")

        client.explicit.post(optionalStringParameter: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalStringProperty200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalStringProperty")

        client.explicit.post(optionalStringProperty: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalStringHeader200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalStringHeader")

        client.explicit.postOptionalStringHeader { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalClassParameter200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalClassParameter")

        client.explicit.post(optionalClassParameter: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalClassProperty200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalClassProperty")

        client.explicit.post(optionalClassProperty: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalArrayParameter200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalArrayParameter")

        client.explicit.post(optionalArrayParameter: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalArrayProperty200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalArrayProperty")

        client.explicit.post(optionalArrayProperty: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalArrayHeader200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalArrayHeader")

        client.explicit.postOptionalArrayHeader { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_explicit_postOptionalIntegerProperty200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.postOptionalIntegerProperty")

        client.explicit.post(optionalIntegerProperty: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_implicit_putOptionalHeader200() throws {
        let expectation = XCTestExpectation(description: "Call explicit.putOptionalHeader")

        client.implicit.putOptionalHeader { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
