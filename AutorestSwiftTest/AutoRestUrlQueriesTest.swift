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

class AutoRestUrlTest: XCTestCase {
    var client: AutoRestUrlTestClient!

    override func setUpWithError() throws {
        client = try AutoRestUrlTestClient(
            globalStringPath: "globalStringPath",
            authPolicy: AnonymousAccessPolicy(),
            withOptions: AutoRestUrlTestClientOptions()
        )
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

    func test_Queries_getIntOneMillion200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getIntOneMillion succeed")

        client.queries.getIntOneMillion { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getIntOneMillion failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getIntNegativeOneMillion200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getIntNegativeOneMillion succeed")

        client.queries.getIntNegativeOneMillion { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getIntOneMillion failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getTenBillion200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getTenBillion succeed")

        client.queries.getTenBillion { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getTenBillion failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_getNegativeTenBillion200() throws {
        let expectation = XCTestExpectation(description: "Call queries.getNegativeTenBillion succeed")

        client.queries.getNegativeTenBillion { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.getTenBillion failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleDecimalPositive200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleDecimalPositive succeed")

        client.queries.doubleDecimalPositive { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.doubleDecimalPositive failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleDecimalNegative200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleDecimalNegative succeed")

        client.queries.doubleDecimalNegative { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.doubleDecimalNegative failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatScientificNegative200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatScientificNegative succeed")

        client.queries.floatScientificNegative { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.floatScientificNegative failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_enumNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.enumNull succeed")

        client.queries.enumNull { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.enumNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateNull succeed")

        client.queries.dateNull { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.dateNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_dateTimeNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.dateTimeNull succeed")

        client.queries.dateTimeNull { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.dateTimeNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatNull succeed")

        client.queries.floatNull { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.floatNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_doubleNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.doubleNull succeed")

        client.queries.doubleNull { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.floatNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvValid succeed")

        let options = Queries.ArrayStringCsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringCsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringCsvValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringPipesValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringPipesValid succeed")

        let options = Queries.ArrayStringPipesValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringPipesValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringPipesValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringSsvValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringSsvValid succeed")

        let options = Queries.ArrayStringSsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringSsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringSsvValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringTsvValid200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringTsvValid succeed")

        let options = Queries.ArrayStringTsvValidOptions(
            arrayQuery: ["ArrayQuery1", "begin!*'();:@ &=+$,/?#[]end", "", ""]
        )

        client.queries.arrayStringTsvValid(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringTsvValid failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringNoCollectionFormatEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringNoCollectionFormatEmpty succeed")

        let options = Queries.ArrayStringNoCollectionFormatEmptyOptions(
            arrayQuery: ["hello", "nihao", "bonjour"]
        )

        client.queries.arrayStringNoCollectionFormatEmpty(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringNoCollectionFormatEmpty failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvEmpty200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvEmpty succeed")

        let options = Queries.ArrayStringCsvEmptyOptions(
            arrayQuery: []
        )

        client.queries.arrayStringCsvEmpty(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringCsvEmpty failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_arrayStringCsvNull200() throws {
        let expectation = XCTestExpectation(description: "Call queries.arrayStringCsvNull succeed")

        let options = Queries.ArrayStringCsvNullOptions(
            arrayQuery: nil
        )

        client.queries.arrayStringCsvNull(withOptions: options) { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.arrayStringCsvNull failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringUrlEncoded200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringUrlEncoded succeed")

        client.queries.stringUrlEncoded { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.stringUrlEncoded failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_stringUnicoded200() throws {
        let expectation = XCTestExpectation(description: "Call queries.stringUnicode succeed")

        client.queries.stringUnicode { result, httpResponse in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                let details = errorDetails(for: error, withResponse: httpResponse)
                print("test failed. error=\(details)")
                XCTFail("Call queries.stringUnicode failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

    func test_Queries_floatScientificPositive200() throws {
        let expectation = XCTestExpectation(description: "Call queries.floatScientificPositive succeed")

        client.queries.floatScientificPositive { result, _ in
            switch result {
            case .success:
                expectation.fulfill()
            case let .failure(error):
                print("test failed. error=\(error.message)")
                XCTFail("Call queries.floatScientificPositive failed")
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
