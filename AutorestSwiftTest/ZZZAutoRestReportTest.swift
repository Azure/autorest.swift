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

class ZZZAutoRestReportTest: XCTestCase {
    var client: AutoRestReportClient!

    // The 4 mobile test swerver swaggers are:
    // 1. custom-baseUrl.json
    // 2. xms-error-response.json
    // 3. body-integer.json
    // 4. url.json
    // The following strings are the prefix of the mobile tests from AutoRest TestServer
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
        client = try AutoRestReportClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestReportClientOptions()
        )
    }

    // Calculate the nobile test coverage & total test coverage
    // List the mobile tests which passed and failed
    private func printCoverage(for allTests: [String: Int32]) {
        let passedTest = allTests.filter { $0.value > 0 }
        let totalCount = allTests.count
        let passedCount = passedTest.count

        guard totalCount > 0 else {
            return
        }

        let coverage: Float = Float(passedCount) / Float(totalCount) * 100

        print("Passed Test=\(passedCount), Total Test=\(totalCount), Coverage=\(String(format: "%.2f", coverage))%")

        /* Uncomment this to print the list of passed/failed tests */
        /*
        let failedTest = allTests.filter { $0.value == 0 }

        if failedTest.count > 0 {
            print("Failed tests")
            print("-------------------")
            for test in failedTest { print(test.key) }
        }
        */

     private func printReport(allTests: [String: Int32]) {
        let mobileTests = getMobileTests(with: allTests)
        printCoverage(for: mobileTests)
        printCoverage(for: allTests)
     }

    // Return the list of mobile tests
    private func getMobileTests(with report: [String: Int32]) -> [String: Int32] {
        return report.filter {
            for prefix in mobileTestsPrefix {
                if $0.key.hasPrefix(prefix),
                    // test name 'expectedEnum' is from non-string-enum.json, not part of the mobile test
                    $0.key != "expectedEnum" {
                    return true
                }
            }
            return false
        }
    }

    func test_ReportFile_getReport() throws {
        let expectation = XCTestExpectation(description: "Call getReport succeed")

        client.autoRestReportService.getReport { result, _ in
            switch result {
            case let .success(allTests):
                XCTAssert(allTests.count > 0)

                let mobileTests = self.getMobileTests(with: allTests)
                print("Mobile Coverage:")
                self.printCoverage(for: mobileTests)
                print("Total Coverage:")
                self.printCoverage(for: allTests)
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

        client.autoRestReportService.getOptionalReport { result, _ in
            switch result {
            case let .success(optionalReport):
                XCTAssert(optionalReport.count > 0)
                print("\n\nOptional Coverage:")
                self.printCoverage(for: optionalReport)
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call getOptionalReport failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
