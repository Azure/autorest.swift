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

    func test_Paths_byteNull_404() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteNull")

        client.paths.byteNull(bytePath: Data()) { result, httpResponse in
            switch result {
            case .success:
                XCTFail("Call paths.byteNull failed")
            case .failure:
                XCTAssertEqual(httpResponse?.statusCode, 404)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteEmpty")

        client.paths.byteEmpty { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call paths.byteEmpty failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_byteMultiByte_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.byteMultiByte")

        guard let bytePath = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8)?.base64EncodedData() else {
            return
        }
        client.paths.byteMultiByte(bytePath: bytePath) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call paths.byteMultiByte failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanTrue_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanTrue")

        client.paths.getBooleanTrue { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getBooleanTrue failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getBooleanFalse_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getBooleanFalse")

        client.paths.getBooleanFalse { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getBooleanFalse failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_enumValid_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.enumValid")

        client.paths.enumValid(enumPath: .greenColor) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.enumValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateValid_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateValid")

        client.paths.dateValid { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.dateValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_dateTimeValid_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.dateTimeValid succeed")

        client.paths.dateTimeValid { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.dateTimeValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getIntOneMillion_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getIntOneMillion succeed")

        client.paths.getIntOneMillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getIntOneMillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getIntNegativeOneMillion_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getIntNegativeOneMillion")

        client.paths.getIntNegativeOneMillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getIntNegativeOneMillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getTenBillion_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getTenBillion")

        client.paths.getTenBillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_getNegativeTenBillion_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.getNegativeTenBillion")

        client.paths.getNegativeTenBillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getNegativeTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_doubleDecimalPositive_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.doubleDecimalPositive")

        client.paths.doubleDecimalPositive { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.doubleDecimalPositive failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_doubleDecimalNegative_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.doubleDecimalNegative")

        client.paths.doubleDecimalNegative { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.doubleDecimalNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_floatScientificPositive_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.floatScientificPositive")

        client.paths.floatScientificPositive { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.floatScientificPositive failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_floatScientificNegative_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.floatScientificNegative")

        client.paths.floatScientificNegative { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.floatScientificNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringEmpty")

        client.paths.stringEmpty { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.stringEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringUrlEncoded_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringUrlEncoded")

        client.paths.stringUrlEncoded { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.stringUrlEncoded failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringUnicode_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringUnicode")

        client.paths.stringUnicode { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.stringUnicode failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_arrayStringCsvValid_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.arrayStringCsvValid")

        client.paths
            .arrayCsvInPath(arrayPath: ["ArrayPath1", "begin!*'();:@ &=+$,/?#[]end", "", ""]) { result, httpResponse in
                switch result {
                case .success:
                    XCTAssertEqual(httpResponse?.statusCode, 200)
                case let .failure(error):
                    let details = errorDetails(for: error, withResponse: httpResponse)
                    XCTFail("Call paths.arrayStringCsvValid failed. error=\(details)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_base64Url_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.base64Url")

        client.paths.base64Url(base64UrlPath: Base64Data(string: "lorem")!) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.base64Url failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_stringUrlNonEncoded_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.stringUrlNonEncoded")

        client.paths.stringUrlNonEncoded { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.getTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Paths_unixTimeUrl_200() throws {
        let expectation = XCTestExpectation(description: "Call paths.unixTimeUrl")

        guard let date = ISO8601DateFormatter().date(from: "2016-04-13T00:00:00Z") else {
            XCTFail("Input is not a date")
            return
        }

        client.paths.unixTimeUrl(unixTimeUrlPath: UnixTime(date)!) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call paths.unixTimeUrl failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
