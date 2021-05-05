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

class AutoRestUrlQuriesTest: XCTestCase {
    var client: AutoRestUrlTestClient!

    override func setUpWithError() throws {
        client = try AutoRestUrlTestClient(
            globalStringPath: "globalStringPath",
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestUrlTestClientOptions()
        )
    }

    func test_Queries_byteNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteNull")

        client.queries.byteNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call queries.byteNull failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_byteEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteEmpty")

        client.queries.byteEmpty { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call queries.byteEmpty failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_byteMultiByte_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.byteMultiByte")

        guard let byteQuery = "啊齄丂狛狜隣郎隣兀﨩".data(using: .utf8)?.base64EncodedData() else {
            return
        }
        let options = ByteMultiByteOptions(byteQuery: byteQuery)
        client.queries.byteMultiByte(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call queries.byteMultiByte failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getBooleanNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanNull")

        client.queries.getBooleanNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case .failure:
                XCTFail("Call queries.byteMultiByte failed")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getBooleanTrue_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanTrue")

        client.queries.getBooleanTrue { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getBooleanTrue failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getBooleanFalse_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getBooleanFalse")

        client.queries.getBooleanFalse { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getBooleanFalse failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_enumValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.enumValid")

        let options = EnumValidOptions(enumQuery: .greenColor)
        client.queries.enumValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.enumValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateValid")

        client.queries.dateValid { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.dateValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateTimeValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateTimeValid")

        client.queries.dateTimeValid { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.dateTimeValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getIntOneMillion_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getIntOneMillion")

        client.queries.getIntOneMillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getIntOneMillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getIntNegativeOneMillion_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getIntNegativeOneMillion")

        client.queries.getIntNegativeOneMillion { result, httpResponse in
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

    func test_Queries_getTenBillion_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getTenBillion")

        client.queries.getTenBillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getNegativeTenBillion_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getNegativeTenBillion")

        client.queries.getNegativeTenBillion { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getNegativeTenBillion failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleDecimalPositive_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleDecimalPositive")

        client.queries.doubleDecimalPositive { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.doubleDecimalPositive failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleDecimalNegative_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleDecimalNegative")

        client.queries.doubleDecimalNegative { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.doubleDecimalNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatScientificNegative_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatScientificNegative")

        client.queries.floatScientificNegative { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.floatScientificNegative failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_enumNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.enumNull")

        client.queries.enumNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.enumNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateNull")

        client.queries.dateNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.dateNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateTimeNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateTimeNull")

        client.queries.dateTimeNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.dateTimeNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getIntNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getIntNull")

        client.queries.getIntNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getIntNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getLongNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getLongNull")

        client.queries.getLongNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.getLongNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringEmpty")

        client.queries.stringEmpty { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.stringEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringNull")

        client.queries.stringNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.stringNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatNull")

        client.queries.floatNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.floatNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleNull")

        client.queries.doubleNull { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call  queries.doubleNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvValid")

        let options = ArrayStringCsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringCsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringCsvValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringPipesValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringPipesValid")

        let options = ArrayStringPipesValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringPipesValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringPipesValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringSsvValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringSsvValid")

        let options = ArrayStringSsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringSsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringSsvValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringTsvValid_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringTsvValid")

        let options = ArrayStringTsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringTsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringTsvValid failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringNoCollectionFormatEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringNoCollectionFormatEmpty")

        let options = ArrayStringNoCollectionFormatEmptyOptions(
            arrayQuery: ["hello", "nihao", "bonjour"]
        )

        client.queries.arrayStringNoCollectionFormatEmpty(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringNoCollectionFormatEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvEmpty_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvEmpty")

        let options = ArrayStringCsvEmptyOptions(
            arrayQuery: []
        )

        client.queries.arrayStringCsvEmpty(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringCsvEmpty failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvNull_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvNull")

        let options = ArrayStringCsvNullOptions(
            arrayQuery: nil
        )

        client.queries.arrayStringCsvNull(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.arrayStringCsvNull failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringUrlEncoded_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringUrlEncoded")

        client.queries.stringUrlEncoded { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.stringUrlEncoded failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringUnicoded_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringUnicode")

        client.queries.stringUnicode { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.stringUnicode failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatScientificPositive_200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatScientificPositive")

        client.queries.floatScientificPositive { result, httpResponse in
            switch result {
            case .success:
                XCTAssertEqual(httpResponse?.statusCode, 200)
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                XCTFail("Call queries.floatScientificPositive failed. error=\(details)")
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
