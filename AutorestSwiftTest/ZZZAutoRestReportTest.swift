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
    private func printReport(report: [String: Int32]) {
        let mobileTest = getMobileTests(with: report)
        let passedTest = report.filter { $0.value > 0 }
        let mobilePassedTest = mobileTest.filter { $0.value > 0 }

        let totalTestCount = report.count
        let passedCount = passedTest.count

        let mobileTestCount = mobileTest.count
        let mobilePassedCount = mobilePassedTest.count

        let coverage: Float = Float(passedCount) / Float(totalTestCount) * 100

        if mobileTestCount > 0 {
            let mobileCoverage: Float = Float(mobilePassedCount) / Float(mobileTestCount) * 100

            /* Uncomment this to print the list of passed/failed tests */
            /*
             let mobileFailedTest = mobileTest.filter { $0.value == 0 }

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
             */
            print(
                "Mobile Passed Test=\(mobilePassedCount), Mobile Total Test=\(mobileTestCount), Coverage=\(String(format: "%.2f", mobileCoverage))%"
            )
        }

        // List all passed tests which are not part of the mobile tests
        /* Uncomment this to print the list of passed/failed tests */
        /*
         let otherPassedTest = passedTest.difference(from: mobilePassedTest)
         if otherPassedTest.count > 0 {
             print("\nOther passed tests")
             print("-------------------")
             for test in otherPassedTest { print(test.key) }
         }
         */
        print("Pass Test=\(passedCount), Total Test=\(totalTestCount), Coverage=\(String(format: "%.2f", coverage))%")
    }

    // Return the list of mobile tests
    private func getMobileTests(with report: [String: Int32]) -> [String: Int32] {
        return report.filter {
            for prefix in mobileTestsPrefix {
                if $0.key.hasPrefix(prefix),
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
            case let .success(report):
                XCTAssert(report.count > 0)
                print("\nCoverage:")
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

        client.autoRestReportService.getOptionalReport { result, _ in
            switch result {
            case let .success(optionalReport):
                XCTAssert(optionalReport.count > 0)
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
