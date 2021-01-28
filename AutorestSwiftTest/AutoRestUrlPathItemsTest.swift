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

    func test_Pathitems_getGlobalQueryNull_200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_getGlobalQueryNull")

        let options = PathItems.GetGlobalQueryNullOptions(
            pathItemStringQuery: "pathItemStringQuery",
            localStringQuery: "localStringQuery"
        )
        client.pathItems.getGlobalQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call pathitems_getGlobalQueryNull failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_getGlobalAndLocalQueryNull_200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems.getGlobalAndLocalQueryNull")

        let options = PathItems.GetGlobalAndLocalQueryNullOptions(pathItemStringQuery: "pathItemStringQuery")
        client.pathItems.getGlobalAndLocalQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call pathitems.getGlobalAndLocalQueryNull failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_getLocalPathItemQueryNull_200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_getLocalPathItemQueryNull")
        client.globalStringQuery = "globalStringQuery"
        client.pathItems.getLocalPathItemQueryNull(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath"
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call pathitems_getLocalPathItemQueryNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Pathitems_listAllWithValues_200() throws {
        let expectation = XCTestExpectation(description: "Call pathitems_listAllWithValues")
        client.globalStringQuery = "globalStringQuery"
        let options = PathItems.GetAllWithValuesOptions(
            pathItemStringQuery: "pathItemStringQuery",
            localStringQuery: "localStringQuery"
        )
        client.pathItems.getAllWithValues(
            pathItemStringPath: "pathItemStringPath",
            localStringPath: "localStringPath",
            withOptions: options
        ) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call pathitems_listAllWithValues failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
