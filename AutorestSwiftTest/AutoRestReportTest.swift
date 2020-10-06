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

import AutoRestReport
import AzureCore
import Foundation
import XCTest

class AutoRestReportTest: XCTestCase {
    var client: AutoRestReportClient!

    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }

        client = try AutoRestReportClient(
            baseUrl: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestReportClientOptions()
        )
    }

    func test_ReportFile_getReport() throws {
        let expectation = XCTestExpectation(description: "Call getReport succeed")
        let failedExpectation = XCTestExpectation(description: "Call getReport failed")
        failedExpectation.isInverted = true

        client.autorestreportservice.getReport { result, _ in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 598)
                XCTAssertEqual(data["MultipleInheritanceCatGet"], 0)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_ReportFile_getOptionalReport() throws {
        let expectation = XCTestExpectation(description: "Call getOptionalReport succeed")
        let failedExpectation = XCTestExpectation(description: "Call getOptionalReport failed")
        failedExpectation.isInverted = true

        client.autorestreportservice.getOptionalReport { result, _ in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 41)
                XCTAssertEqual(data["getDecimalInvalid"], 0)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                failedExpectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
