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
        client = try AutoRestResourceFlatteningTestClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestResourceFlatteningTestClientOptions()
        )
    }

    func test_resourceFlattening_getArray() throws {
        let expectation = XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getArray succeed")

        client.autoRestResourceFlatteningTestService.getArray { result, httpResponse in
            switch result {
            case let .success(products):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(products.count, 3)

                let first = products[0]
                XCTAssertEqual(first.id, "1")
                XCTAssertEqual(first.provisioningStateValues, .oK)
                XCTAssertEqual(first.pName, "Product1")
                XCTAssertEqual(first.typePropertiesType, "Flat")
                XCTAssertEqual(first.location, "Building 44")
                XCTAssertEqual(first.name, "Resource1")
                XCTAssertEqual(first.provisioningState, "Succeeded")
                XCTAssertEqual(first.type, "Microsoft.Web/sites")
                XCTAssertEqual(first.tags?["tag1"], "value1")
                XCTAssertEqual(first.tags?["tag2"], "value3")

                let second = products[1]
                XCTAssertEqual(second.id, "2")
                XCTAssertEqual(second.name, "Resource2")
                XCTAssertEqual(second.location, "Building 44")

                let third = products[2]
                XCTAssertEqual(third.id, "3")
                XCTAssertEqual(third.name, "Resource3")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getArray failed")
            }
            expectation.fulfill()
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
        client.autoRestResourceFlatteningTestService.put(array: array) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.putArray failed")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    // FIXME: Test
//    func test_resourceFlattening_getDictionary() throws {
//        let expectation =
//            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getDictionary succeed")
//        client.autoRestResourceFlatteningTestService.getDictionary { result, httpResponse in
//            switch result {
//            case let .success(products):
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//                XCTAssertEqual(products.count, 3)
//                XCTAssertEqual(products["Product1"]?.id, "1")
//                XCTAssertEqual(
//                    products["Product1"]?.provisioningStateValues,
//                    FlattenedProductPropertiesProvisioningStateValues.oK
//                )
//                XCTAssertEqual(products["Product1"]?.typePropertiesType, "Flat")
//                XCTAssertEqual(products["Product1"]?.location, "Building 44")
//                XCTAssertEqual(products["Product1"]?.name, "Resource1")
//                XCTAssertEqual(products["Product1"]?.type, "Microsoft.Web/sites")
//                XCTAssertEqual(products["Product1"]?.tags?["tag1"], "value1")
//                XCTAssertEqual(products["Product1"]?.tags?["tag2"], "value3")
//                XCTAssertEqual(
//                    products["Product1"]?.provisioningState,
//                    FlattenedProductPropertiesProvisioningStateValues.succeeded.rawValue
//                )
//                XCTAssertEqual(products["Product2"]?.id, "2")
//                XCTAssertEqual(products["Product2"]?.name, "Resource2")
//                XCTAssertEqual(products["Product2"]?.location, "Building 44")
//                XCTAssertEqual(products["Product3"]?.id, "3")
//                XCTAssertEqual(products["Product3"]?.name, "Resource3") case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.getDictionary failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIMXE: Test
//    func test_resourceFlattening_putDictionary() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.putDictionary succeed"
//            )
//        let dictionary = [
//            "Resource1": FlattenedProduct(
//                pName: "Product1",
//                typePropertiesType: "Flat",
//                tags: ["tag1": "value1", "tag2": "value3"],
//                location: "West US"
//            ),
//            "Resource2": FlattenedProduct(
//                pName: "Product2",
//                typePropertiesType: "Flat",
//                location: "Building 44"
//            )
//        ]
//        client.autoRestResourceFlatteningTestService.put(dictionary: dictionary) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.putDictionary failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    func test_resourceFlattening_getResourceCollection() throws {
        let expectation =
            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getResourceCollection succeed")
        client.autoRestResourceFlatteningTestService.getResourceCollection { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call autorestresourceflatteningtestservice.getResourceCollection failed")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    // FIXME: Test
//    func test_resourceFlattening_putResourceCollection() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.putResourceCollection succeed"
//            )
//        let collection = ResourceCollection(
//            productresource: FlattenedProduct(
//                pName: "Azure",
//                typePropertiesType: "Flat",
//                location: "India"
//            ),
//            arrayofresources: [
//                FlattenedProduct(
//                    pName: "Product1",
//                    typePropertiesType: "Flat",
//                    tags: ["tag1": "value1", "tag2": "value3"],
//                    location: "West US"
//                )
//            ],
//            dictionaryofresources: [
//                "Resource1": FlattenedProduct(
//                    pName: "Product1",
//                    typePropertiesType: "Flat",
//                    tags: ["tag1": "value1", "tag2": "value3"],
//                    location: "West US"
//                ),
//                "Resource2": FlattenedProduct(
//                    pName: "Product2",
//                    typePropertiesType: "Flat",
//                    location: "Building 44"
//                )
//            ]
//        )
//        client.autoRestResourceFlatteningTestService.put(resourceCollection: collection) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.putResourceCollection failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIXME: Test
//    func test_resourceFlattening_getWrappedArray() throws {
//        let expectation =
//            XCTestExpectation(description: "Call autorestresourceflatteningtestservice.getWrappedArray succeed")
//        // FIXME: Request path must container array, dictionary or resourcecollection
//        client.autoRestResourceFlatteningTestService.getWrappedArray { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.getWrappedArray failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIXME: Test
//    func test_resourceFlattening_putWrappedArray() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.putWrappedArray succeed"
//            )
//        let wrapped = [
//            WrappedProduct(value: "test")
//        ]
//        // FIXME: Timeout fails
//        client.autoRestResourceFlatteningTestService.put(wrappedArray: wrapped) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.putWrappedArray failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIXME: Test
//    func test_resourceFlattening_putSimpleProduct() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.putSimpleProduct succeed"
//            )
//        let product = SimpleProduct(
//            maxProductDisplayName: "max name",
//            odataValue: "http://foo",
//            productId: "123",
//            description: "product description"
//        )
//        // FIXME: Serialization of flattened object to the wire needs fixing
//        client.autoRestResourceFlatteningTestService.put(simpleProduct: product) { result, httpResponse in
//            switch result {
//            case .success:
//                XCTAssertEqual(httpResponse?.statusCode, 200)
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.putSimpleProduct failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIXME: Test
//    func test_resourceFlattening_putSimpleProductWithGroupingFlattenParameterGroup() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.putSimpleProductWithGroupingFlattenParameterGroup succeed"
//            )
//        let group = FlattenParameterGroup(
//            name: "groupproduct",
//            productId: "123",
//            description: "product description",
//            maxProductDisplayName: "max name",
//            odataValue: "http://foo"
//        )
//        // FIXME: Received body is {} (empty)
//        client.autoRestResourceFlatteningTestService
//            .putSimpleProductWithGrouping(flattenParameterGroup: group) { result, httpResponse in
//                switch result {
//                case .success:
//                    XCTAssertEqual(httpResponse?.statusCode, 200)
//                case let .failure(error):
//                    let details = errorDetails(for: error, withResponse: httpResponse)
//                    print("test failed. error=\(details)")
//                    XCTFail(
//                        "Call autorestresourceflatteningtestservice.putSimpleProductWithGroupingFlattenParameterGroup failed"
//                    )
//                }
//                expectation.fulfill()
//            }
//        wait(for: [expectation], timeout: 5.0)
//    }

    // FIXME: Test
//    func test_resourceFlattening_postFlattenedSimpleProduct() throws {
//        let expectation =
//            XCTestExpectation(
//                description: "Call autorestresourceflatteningtestservice.postFlattenedSimpleProduct succeed"
//            )
//        // FIXME: Serialization of flattened object to the wire needs fixing
//        client.autoRestResourceFlatteningTestService.postFlattenedSimpleProduct(
//            productId: "123",
//            description: "product description",
//            maxProductDisplayName: "max name",
//            odataValue: "http://foo"
//        ) { result, httpResponse in
//            switch result {
//            case .success:
//                expectation.fulfill()
//            case let .failure(error):
//                let details = errorDetails(for: error, withResponse: httpResponse)
//                print("test failed. error=\(details)")
//                XCTFail("Call autorestresourceflatteningtestservice.postFlattenedSimpleProduct failed")
//            }
//            expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 5.0)
//    }
}
