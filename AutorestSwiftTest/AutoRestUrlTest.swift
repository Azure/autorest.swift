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

class AutoRestUrlTest: XCTestCase {
    var client: AutoRestUrlTestClient!

    override func setUpWithError() throws {
        guard let baseUrl = URL(string: "http://localhost:3000") else {
            fatalError("Unable to form base URL")
        }

        client = try AutoRestUrlTestClient(
            globalStringPath: "globalStringPath",
            baseUrl: baseUrl,
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestUrlTestClientOptions()
        )
    }

    func test_Paths_byteNull200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteNull succeed")

        client.paths.byteNull(bytePath: Data()) { result, _ in
            switch result {
            case .success:
                XCTFail("Call paths.byteNull failed")
            case .failure:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteEmpty succeed")

        client.paths.byteEmpty { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Call paths.byteEmpty failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteMultiByte200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteMultiByte succeed")

        guard let bytePath = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8)?.base64EncodedData() else {
            return
        }
        client.paths.byteMultiByte(bytePath: bytePath) { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Call paths.byteMultiByte failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanTrue200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanTrue succeed")

        client.paths.getBooleanTrue { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.getBooleanTrue failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanFalse200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanFalse succeed")

        client.paths.getBooleanFalse { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.getBooleanFalse failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_enumValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.enumValid succeed")

        client.paths.enumValid(enumPath: .greenColor) { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.enumValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateValid succeed")

        client.paths.dateValid { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.dateValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateTimeValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateTimeValid succeed")

        client.paths.dateTimeValid { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call paths.dateTimeValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
    func test_Queries_byteNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteNull succeed")

        let options = Queries.ByteNullOptions(byteQuery: Data())
        client.queries.byteNull(withOptions: options) { result, _ in
            switch result {
            case .success:
                XCTFail("Call queries.byteNull failed")
            case .failure:
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteEmpty succeed")

        client.queries.byteEmpty { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Call queries.byteEmpty failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_byteMultiByte200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteMultiByte succeed")

        guard let byteQuery = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8)?.base64EncodedData() else {
            return
        }
        let options = Queries.ByteMultiByteOptions(byteQuery: byteQuery)
        client.queries.byteMultiByte(withOptions: options) { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Call queries.byteMultiByte failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getBooleanTrue200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanTrue succeed")

        client.queries.getBooleanTrue { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getBooleanTrue failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getBooleanFalse200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanFalse succeed")

        client.queries.getBooleanFalse { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getBooleanFalse failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_enumValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.enumValid succeed")

        let options = Queries.EnumValidOptions(enumQuery: .greenColor)
        client.queries.enumValid(withOptions: options) { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.enumValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateValid succeed")

        client.queries.dateValid { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.dateValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateTimeValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateTimeValid succeed")

        client.queries.dateTimeValid { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.dateTimeValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
