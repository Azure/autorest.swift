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

import AzureCore
import PetStoreInc
import XCTest

class AutoRestEnumExtensibleTest: XCTestCase {
    var client: PetStoreIncClient!

    override func setUpWithError() throws {
        client = try PetStoreIncClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: PetStoreIncClientOptions()
        )
    }

    func test_getByPetId() throws {
        let testValues = [
            ("tommy", "Monday", "1"),
            ("casper", "Weekend", "2"),
            ("scooby", "Thursday", "2.1")
        ]
        let expectation = XCTestExpectation(description: "Call \(#function)")
        expectation.expectedFulfillmentCount = testValues.count
        for item in testValues {
            client.petOperation.getByPetId(petId: item.0) { result, httpResponse in
                switch result {
                case let .success(data):
                    XCTAssertEqual(data.daysOfWeek?.requestString, item.1)
                    XCTAssertEqual(data.intEnum.requestString, item.2)
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTFail("Call \(#function) failed. error=\(details)")
                }
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_addPet() throws {
        let pet = Pet(
            name: "Retriever",
            daysOfWeek: .friday,
            intEnum: .three
        )
        let expectation = XCTestExpectation(description: "Call \(#function)")
        client.petOperation.add(pet: pet) { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.daysOfWeek?.requestString, "Friday")
                XCTAssertEqual(data.intEnum.requestString, "3")
                XCTAssertEqual(data.name, "Retriever")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call \(#function) failed. error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
