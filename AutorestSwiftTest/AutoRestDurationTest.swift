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

import AutoRestDurationTest
import AzureCore
import XCTest

// swiftlint:disable type_body_length file_length
class AutoRestDurationTest: XCTestCase {
    var client: AutoRestDurationTestClient!

    let defaultTimeout = 5.0

    override func setUpWithError() throws {
        client = try AutoRestDurationTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestDurationTestClientOptions()
        )
    }

    func test_getNull() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.duration.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertNil(data)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getInvalid() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")

        client.duration.getInvalid { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call \(#function) succeeded but should have failed.")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"), "Error: \(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_getPositiveDuration() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let expected = Iso8601Duration(string: "P3Y6M4DT12H30M5S")!

        client.duration.getPositiveDuration { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data, expected)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. Error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }

    func test_putPositiveDuration() throws {
        let expectation = XCTestExpectation(description: "Call \(#function)")
        let expected = Iso8601Duration(string: "P123DT22H14M12.011S")!

        client.duration.put(positiveDuration: expected) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTAssert(details.contains("Decoding error"), "Error: \(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: defaultTimeout)
    }
}
