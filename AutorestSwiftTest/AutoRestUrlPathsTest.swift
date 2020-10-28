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

class AutoRestUrlPathsTest: XCTestCase {
    var client: AutoRestUrlTestClient!

    override func setUpWithError() throws {
        client = try AutoRestUrlTestClient(
            globalStringPath: "globalStringPath",
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestUrlTestClientOptions()
        )
    }

    func test_Paths_byteNull200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteNull")

        client.paths.byteNull(bytePath: Data()) { result, _ in
            switch result {
            case .success:
                XCTFail("Call paths.byteNull failed")
            case .failure:
                break
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteEmpty")

        client.paths.byteEmpty { result, _ in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("Call paths.byteEmpty failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteMultiByte200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteMultiByte")

        guard let bytePath = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8)?.base64EncodedData() else {
            return
        }
        client.paths.byteMultiByte(bytePath: bytePath) { result, _ in
            switch result {
            case .success:
                break
            case .failure:
                XCTFail("Call paths.byteMultiByte failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanTrue200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanTrue")

        client.paths.getBooleanTrue { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getBooleanTrue failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanFalse200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanFalse")

        client.paths.getBooleanFalse { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getBooleanFalse failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_enumValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.enumValid")

        client.paths.enumValid(enumPath: .greenColor) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.enumValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateValid")

        client.paths.dateValid { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.dateValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateTimeValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateTimeValid succeed")

        client.paths.dateTimeValid { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.dateTimeValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getIntOneMillion200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getIntOneMillion succeed")

        client.paths.getIntOneMillion { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getIntOneMillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getIntNegativeOneMillion200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getIntNegativeOneMillion")

        client.paths.getIntNegativeOneMillion { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getIntNegativeOneMillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getTenBillion200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getTenBillion")

        client.paths.getTenBillion { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getNegativeTenBillion200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getNegativeTenBillion")

        client.paths.getNegativeTenBillion { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getNegativeTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_doubleDecimalPositive200() throws {
        let expectation = XCTestExpectation(description: "Call paths.doubleDecimalPositive")

        client.paths.doubleDecimalPositive { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.doubleDecimalPositive failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_doubleDecimalNegative200() throws {
        let expectation = XCTestExpectation(description: "Call paths.doubleDecimalNegative")

        client.paths.doubleDecimalNegative { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.doubleDecimalNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_floatScientificNegative200() throws {
        let expectation = XCTestExpectation(description: "Call paths.floatScientificNegative")

        client.paths.floatScientificNegative { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.floatScientificNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringUrlEncoded200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringUrlEncoded")

        client.paths.stringUrlEncoded { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.stringUrlEncoded failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_arrayStringCsvValid200() throws {
        let expectation = XCTestExpectation(description: "Call paths.arrayStringCsvValid")

        client.paths
            .arrayCsvInPath(arrayPath: ["ArrayPath1", "begin!*'();:@ &=+$,/?#[]end", "", ""]) { result, httpResponse in
                switch result {
                case .success:
                    break
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTFail("Call paths.arrayStringCsvValid failed. error=\(details)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_base64Url200() throws {
        let expectation = XCTestExpectation(description: "Call paths.base64Url")

        client.paths.base64Url(base64UrlPath: Data("lorem".utf8)) { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.base64Url failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringUrlNonEncoded200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringUrlNonEncoded")

        client.paths.stringUrlNonEncoded { result, httpResponse in
            switch result {
            case .success:
                break
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
