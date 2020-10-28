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

import AutoRestUrlTest
import AzureCore
import XCTest

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
// swiftlint:disable file_length

class AutoRestUrlPathItemsTest: XCTestCase {
    var client: AutoRestUrlTestClient!

    override func setUpWithError() throws {
        client = try AutoRestUrlTestClient(
            globalStringPath: "globalStringPath",
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestUrlTestClientOptions()
        )
    }

    func test_Pathitems_getGlobalQueryNull200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_getGlobalQueryNull succeed")

        let options = PathItems.GetGlobalQueryNullOptions(
            pathItemStringQuery: "pathItemStringQuery",
            localStringQuery: "localStringQuery"
        )
        client.pathitems.getGlobalQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call pathitems_getGlobalQueryNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_getGlobalAndLocalQueryNull200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems.getGlobalAndLocalQueryNull succeed")

        let options = PathItems.GetGlobalAndLocalQueryNullOptions(pathItemStringQuery: "pathItemStringQuery")
        client.pathitems.getGlobalAndLocalQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call pathitems.getGlobalAndLocalQueryNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_getLocalPathItemQueryNull200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_getLocalPathItemQueryNull succeed")
        client.globalStringQuery = "globalStringQuery"
        client.pathitems.getLocalPathItemQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath"
        ) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call pathitems_getLocalPathItemQueryNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_listAllWithValues200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_listAllWithValues succeed")
        client.globalStringQuery = "globalStringQuery"
        let options = PathItems.GetAllWithValuesOptions(
            pathItemStringQuery: "pathItemStringQuery",
            localStringQuery: "localStringQuery"
        )
        client.pathitems.listAllWithValues(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call pathitems_listAllWithValues failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
