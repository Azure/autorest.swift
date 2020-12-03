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

import AutoRestPagingTest
import AzureCore
import XCTest

class AutoRestPagingTest: XCTestCase {
    var client: AutoRestPagingTestClient!

    override func setUpWithError() throws {
        client = try AutoRestPagingTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestPagingTestClientOptions()
        )
    }

    func test_listNoItemNamePages200() throws {
        let expectation = XCTestExpectation(description: "Call paging.listNoItemNamePages")

        client.paging.listNoItemNamePages { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(pagedCollection.underestimatedCount, 1)

                var allProducts: [Product] = []

                pagedCollection.nextItem { result in
                    switch result {
                    case let .success(product):
                        allProducts.append(product)
                    case .failure:
                        XCTFail("\(expectation.description) failed in nextItem")
                    }
                }

                XCTAssertEqual(allProducts.count, 1)
                XCTAssertEqual(allProducts[0].properties?.name, "Product")
                XCTAssertEqual(allProducts[0].properties?.id, 1)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listNullNextLinkNamePages200() throws {
        let expectation = XCTestExpectation(description: "Call paging.listNullNextLinkNamePages")

        client.paging.listNullNextLinkNamePages { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(pagedCollection.underestimatedCount, 1)
                var allProducts: [Product] = []

                pagedCollection.nextItem { result in
                    switch result {
                    case let .success(product):
                        allProducts.append(product)
                    case .failure:
                        XCTFail("\(expectation.description) failed in nextItem")
                    }
                }

                XCTAssertEqual(allProducts.count, 1)
                XCTAssertEqual(allProducts[0].properties?.name, "Product")
                XCTAssertEqual(allProducts[0].properties?.id, 1)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listSinglePages200() throws {
        let expectation = XCTestExpectation(description: "Call paging.listSinglePages")

        client.paging.listSinglePages { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                var noOfPages = 1
                pagedCollection.forEachPage { _ in
                    noOfPages += 1

                    if pagedCollection.isExhausted {
                        XCTAssertEqual(noOfPages, 1)
                        return false
                    } else {
                        return true
                    }
                }

                if pagedCollection.isExhausted {
                    XCTAssertEqual(noOfPages, 1)
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listMultiplePages200() throws {
        let expectation = XCTestExpectation(description: "Call paging.listMultiplePages")

        client.paging.listMultiplePages { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                var noOfPages = 1
                pagedCollection.forEachPage { _ in
                    noOfPages += 1

                    if pagedCollection.isExhausted {
                        XCTAssertEqual(noOfPages, 10)
                        return false
                    } else {
                        return true
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    // FIXME: Causes excessive calls to testserver
//    func test_listWithQueryParams200() throws {
//        let expectation = XCTestExpectation(description: "Call paging.listWithQueryParams")
//
//        client.paging.listWithQueryParams(requiredQueryParameter: 100) { result, httpResponse in
//            switch result {
//            case let .success(pagedCollection):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//
//                var noOfPages = 1
//                pagedCollection.forEachPage { _ in
//                    noOfPages += 1
//
//                    if pagedCollection.isExhausted {
//                        XCTAssertEqual(noOfPages, 2)
//                        return false
//                    } else {
//                        return true
//                    }
//                }
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                XCTFail("\(expectation.description). error=\(details)")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    func test_getMultiplePagesWithOffset200() throws {
        let expectation = XCTestExpectation(description: "Call paging.getMultiplePagesWithOffset")

        client.paging.getMultiplePagesWithOffset(offset: 100) { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                var noOfPages = 1
                var allProducts: [Product] = []
                pagedCollection.forEachPage { products in
                    noOfPages += 1

                    allProducts.append(contentsOf: products)

                    if pagedCollection.isExhausted {
                        XCTAssertEqual(noOfPages, 10)
                        let product = allProducts[allProducts.count - 1]
                        XCTAssertEqual(product.properties?.id, 110)
                        return false
                    } else {
                        return true
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_listOdataMultiplePages200() throws {
        let expectation = XCTestExpectation(description: "Call paging.listOdataMultiplePages")

        client.paging.listOdataMultiplePages { result, httpResponse in
            switch result {
            case let .success(pagedCollection):
                XCTAssertEqual(httpResponse?.statusCode, 200)

                var noOfPages = 1
                pagedCollection.forEachPage { _ in
                    noOfPages += 1

                    if pagedCollection.isExhausted {
                        XCTAssertEqual(noOfPages, 10)
                        return false
                    } else {
                        return true
                    }
                }
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("\(expectation.description). error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
