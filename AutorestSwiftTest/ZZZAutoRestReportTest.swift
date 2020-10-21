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

extension Dictionary {
    func difference(from other: Dictionary) -> Dictionary {
        let thisKeys = Set(keys)
        let otherKeys = Set(other.keys)
        let differentKeys = thisKeys.symmetricDifference(otherKeys)
        return filter { differentKeys.contains($0.key) }
    }
}

class ZZZAutoRestReportTest: XCTestCase {
    var client: AutoRestReportClient!

    let mobileTestsPrefix = [
        // custom-baseUrl.json
        "CustomBase",
        // xms-error-response.json
        "expected", "animalNotFoundError", "linkNotFoundError", "stringError", "intError",
        // body-integer.json
        "putInteger", "putLong", "putUnixTime", "getInteger", "getLong", "getUnixTime", "getInvalidUnixTime",
        "getNullUnixTime",
        // url.json
        "UrlPathItem", "UrlQueries", "UrlPaths"
    ]

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

    private func printReport(report: [String: Int32]) {
        let mobileTest = getMobileTests(with: report)
        let passedTest = report.filter { $0.value > 0 }
        let mobilePassedTest = mobileTest.filter { $0.value > 0 }
        let mobileFailedTest = mobileTest.filter { $0.value == 0 }

        let totalTestCount = report.count
        let passedCount = passedTest.count

        let mobileTestCount = mobileTest.count
        let mobilePassedCount = mobilePassedTest.count

        let coverage: Float = Float(passedCount) / Float(totalTestCount)

        if mobileTestCount > 0 {
            let mobileCoverage: Float = Float(mobilePassedCount) / Float(mobileTestCount)

            if mobilePassedTest.count > 0 {
                print("Passed mobile tests")
                print("-------------------")
                for test in mobilePassedTest { print(test.key) }
            }

            if mobileFailedTest.count > 0 {
                print("Failed mobile tests")
                print("-------------------")
                for test in mobileFailedTest { print(test.key) }
            }

            print("Mobile Passed Test=\(mobilePassedCount) Mobile Test=\(mobileTestCount) Coverage=\(mobileCoverage)")
        }

        let otherPassedTest = passedTest.difference(from: mobilePassedTest)
        if otherPassedTest.count > 0 {
            print("\nOther passed tests")
            print("-------------------")
            for test in otherPassedTest { print(test.key) }
        }
        print("\nPass Test=\(passedCount) Total Test=\(totalTestCount) Coverage=\(coverage)")
    }

    private func getMobileTests(with report: [String: Int32]) -> [String: Int32] {
        return report.filter {
            for prefix in mobileTestsPrefix {
                if $0.key.contains(prefix) {
                    return true
                }
            }
            return false
        }
    }

    func test_ReportFile_getReport() throws {
        let expectation = XCTestExpectation(description: "Call getReport succeed")

        client.autorestreportservice.getReport { result, _ in
            switch result {
            case let .success(report):
                print("Coverage:")
                self.printReport(report: report)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getReport failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_ReportFile_getOptionalReport() throws {
        let expectation = XCTestExpectation(description: "Call getOptionalReport succeed")

        client.autorestreportservice.getOptionalReport { result, _ in
            switch result {
            case let .success(optionalReport):
                print("Optional Coverage:")
                self.printReport(report: optionalReport)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getOptionalReport failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
