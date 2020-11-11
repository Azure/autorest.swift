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

import Foundation

import AutoRestSwaggerBat
import AzureCore
import XCTest

class AutoRestSwaggerBatTest: XCTestCase {
    var client: AutoRestSwaggerBatClient!

    override func setUpWithError() throws {
        client = try AutoRestSwaggerBatClient(
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestSwaggerBatClientOptions()
        )
    }

    func test_string_getNull_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getNull")

        client.stringOperation.getNull { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertNil(data)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.getNull failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_putNull_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.putNull")

        client.stringOperation.put(null: nil) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.getNull failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_getEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getEmpty")

        client.stringOperation.getEmpty { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, "\"\"")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.getNull failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_putEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.putEmpty")

        client.stringOperation.putEmpty { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.putEmpty failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_listMbcs_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.listMbcs")

        client.stringOperation.listMbcs { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data.count, 70)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.listMbcs failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_putMbcs_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.putMbcs")

        client.stringOperation.putMbcs { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.putMbcs failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_getWhitespace_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getWhitespace")

        client.stringOperation.getWhitespace { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(
                    data,
                    "\"    Now is the time for all good men to come to the aid of their country    \""
                )
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.getWhitespace failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_putWhitespace_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.putWhitespace")

        client.stringOperation.putWhitespace { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call stringOperation.putWhitespace failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_getNotProvided_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getNotProvided")

        client.stringOperation.getNotProvided { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, "")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getNotProvided.putWhitespace failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_getBase64Encoded_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getBase64Encoded")

        client.stringOperation.getBase64Encoded { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(
                    String(decoding: data, as: UTF8.self),
                    "\"YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjQ=\""
                )
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getNotProvided.getBase64Encoded failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_getBase64UrlEncoded_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.getBase64UrlEncoded")

        client.stringOperation.getBase64UrlEncoded { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                let str = String(decoding: data, as: UTF8.self)
                XCTAssertEqual(str, "\"YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw\"")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getNotProvided.getBase64UrlEncoded failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_string_putBase64UrlEncoded_200() throws {
        let expectation = XCTestExpectation(description: "Call stringOperation.putBase64UrlEncoded")

        let data = "\"YSBzdHJpbmcgdGhhdCBnZXRzIGVuY29kZWQgd2l0aCBiYXNlNjR1cmw\"".data(using: .utf8) ?? Data()
        client.stringOperation.put(base64UrlEncoded: data) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call getNotProvided.getBase64UrlEncoded failed error=\(details)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_getNotExpandable_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.getNotExpandable")

        client.enumOperation.getNotExpandable { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, Colors.redColor)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call enumOperation.getNotExpandable failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_putNotExpandable_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.putNotExpandable")

        client.enumOperation.put(notExpandable: Colors.redColor) { result, httpResponse in
            switch result {
            case let .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call enumOperation.putNotExpandable failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_getReferenced_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.getReferenced")

        client.enumOperation.getReferenced { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data, Colors.redColor)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call enumOperation.getReferenced failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_putReferenced_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.putReferenced")

        client.enumOperation.put(referenced: Colors.redColor) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call enumOperation.putReferenced failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_getReferencedConstant_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.getReferencedConstant")

        client.enumOperation.getReferencedConstant { result, httpResponse in
            switch result {
            case let .success(data):
                XCTAssertEqual(httpResponse?.statusCode, 200)
                XCTAssertEqual(data.field1, "Sample String")
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call enumOperation.getReferencedConstant failed error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_enum_putReferencedConstant_200() throws {
        let expectation = XCTestExpectation(description: "Call enumOperation.putReferencedConstant")

        client.enumOperation
            .put(referencedConstant: RefColorConstant()) { result, httpResponse in
                switch result {
                case .success:
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTFail("Call enumOperation.putReferencedConstant failed error=\(details)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 5.0)
    }
}
