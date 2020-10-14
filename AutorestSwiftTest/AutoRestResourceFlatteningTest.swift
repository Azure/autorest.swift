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

import AutoRestResourceFlatteningTest
import AzureCore
import Foundation
import XCTest

class AutoRestResourceFlatteningTest: XCTestCase {
    var client: AutoRestResourceFlatteningTestClient!

    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }

        client = try AutoRestResourceFlatteningTestClient(
            baseUrl: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestResourceFlatteningTestClientOptions()
        )
    }

    private func errorDetails(for error: AzureError, withResponse response: HTTPResponse?) -> String {
        var details: String
        if let data = response?.data {
            details = String(data: data, encoding: .utf8)!
        } else {
            details = error.message
        }
        return details
    }

    func test_resourceFlattening_getArray() throws {
        let expectation = XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getArray succeed")

        client.autorestresourceflatteningtestservice.getArray { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getArray failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putArray() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putArray succeed"
            )
        let array = [
            Resource(tags: ["tag1": "value1", "tag2": "value3"], location: "West US"),
            Resource(location: "Building 44")
        ]
        client.autorestresourceflatteningtestservice.put(array: array) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putArray failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_getDictionary() throws {
        let expectation =
            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getDictionary succeed")
        client.autorestresourceflatteningtestservice.getDictionary { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getDictionary failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putDictionary() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putDictionary succeed"
            )
        let dictionary = [
            "Resource1": FlattenedProduct(
                type: "Flat",
                tags: ["tag1": "value1", "tag2": "value3"],
                location: "West US",
                name: "Product1"
            ),
            "Resource2": FlattenedProduct(
                type: "Flat",
                location: "Building 44",
                name: "Product2"
            )
        ]
        // FIXME: Flattened parameters should be sent on the wire under "properties" object
        client.autorestresourceflatteningtestservice.put(dictionary: dictionary) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putDictionary failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_getResourceCollection() throws {
        let expectation =
            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getResourceCollection succeed")
        client.autorestresourceflatteningtestservice.getResourceCollection { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getResourceCollection failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putResourceCollection() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putResourceCollection succeed"
            )
        let collection = ResourceCollection(
            productresource: FlattenedProduct(
                type: "Flat",
                location: "India",
                name: "Azure"
            ),
            arrayofresources: [
                FlattenedProduct(
                    type: "Flat",
                    tags: ["tag1": "value1", "tag2": "value3"],
                    location: "West US",
                    name: "Product1"
                )
            ],
            dictionaryofresources: [
                "Resource1": FlattenedProduct(
                    type: "Flat",
                    tags: ["tag1": "value1", "tag2": "value3"],
                    location: "West US",
                    name: "Product1"
                ),
                "Resource2": FlattenedProduct(
                    type: "Flat",
                    location: "Building 44",
                    name: "Product2"
                )
            ]
        )
        client.autorestresourceflatteningtestservice.put(resourceCollection: collection) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putResourceCollection failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_getWrappedArray() throws {
        let expectation =
            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getWrappedArray succeed")
        client.autorestresourceflatteningtestservice.getWrappedArray { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getWrappedArray failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putWrappedArray() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putWrappedArray succeed"
            )
        let wrapped = [
            WrappedProduct(value: "test")
        ]
        client.autorestresourceflatteningtestservice.put(wrappedArray: wrapped) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putWrappedArray failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putSimpleProduct() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putSimpleProduct succeed"
            )
        let product = SimpleProduct(
            productId: "Product1",
            description: "Description"
        )
        client.autorestresourceflatteningtestservice.put(simpleProduct: product) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putSimpleProduct failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_putSimpleProductWithGroupingFlattenParameterGroup() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.putSimpleProductWithGroupingFlattenParameterGroup succeed"
            )
        let group = FlattenParameterGroup(
            name: "name",
            productId: "Product1",
            description: "Description"
        )
        client.autorestresourceflatteningtestservice
            .putSimpleProductWithGrouping(flattenParameterGroup: group) { result, httpResponse in
                switch result {
                case .success:
                    expectation.fulfill()
                case let .failure(error):
                    let details = self.errorDetails(for: error, withResponse: httpResponse)
                    print("test failed. error=\(details)")
                    XCTFail(
                        "Call autorestresourceflatteningtestservice.putSimpleProductWithGroupingFlattenParameterGroup failed"
                    )
                }
            }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_resourceFlattening_postFlattenedSimpleProduct() throws {
        let expectation =
            XCTestExpectation(
                description: "Call autorestresourceflatteningtestservice.postFlattenedSimpleProduct succeed"
            )
        client.autorestresourceflatteningtestservice.postFlattenedSimpleProduct(
            productId: "Product1",
            description: "Description"
        ) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = self.errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.postFlattenedSimpleProduct failed")
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
