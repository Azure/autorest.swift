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

@testable import AutorestSwiftFramework
import class Foundation.Bundle
import XCTest

final class AutorestSwiftTests: XCTestCase {
    func testSwaggerFromTestServer() throws {
        let yamlfiles = [
            //  "additionalProperties",
            //  "azure-parameter-grouping",
            //  "azure-report",
            //  "azure-resource-x",
            //  "azure-resource",
            //  "azure-special-properties",
            //  "body-array",
            "body-boolean.quirks",
            //  "body-boolean",
            //  "body-byte",
            //  "body-complex",
            "body-date",
            //  "body-datetime-rfc1123",
            //  "body-datetime",
            //  "body-dictionary",
            "body-duration",
            //  "body-file",
            "body-formdata-urlencoded",
            "body-formdata",
            //  "body-integer",
            //  "body-number.quirks",
            //  "body-number",
            //  "body-string.quirks",
            //  "body-string",
            "body-time",
            //  "complex-model",
            //  "constants",
            "custom-baseUrl-more-options",
            //  "custom-baseUrl-paging",
            "custom-baseUrl",
            "extensible-enums-swagger",
            "head-exceptions",
            "head",
            //   "header",
            //   "httpInfrastructure.quirks",
            //   "httpInfrastructure",
            //   "lro",
            //   "media_types",
            //   "model-flattening",
            "multiapi-v1-custom-base-url",
            //   "multiapi-v1",
            "multiapi-v2-custom-base-url",
            "multiapi-v2",
            //   "multiapi-v3",
            //   "multiple-inheritance",
            //   "non-string-enum",
            //    "object-type",
            //    "paging",
            //    "parameter-flattening",
            //    "report",
            //    "required-optional",
            //    "storage",
            "subscriptionId-apiVersion"
            //  "url-multi-collectionFormat",
            //  "url",
            //   "validation",
            //    "xml-service",
            //    "xms-error-responses"
        ]

        for file in yamlfiles {
            XCTAssertTrue(runTestSwaggerFromTestServer(yamlFileName: file))
        }
    }

    func runTestSwaggerFromTestServer(yamlFileName: String) -> Bool {
        print("Test \(yamlFileName).yaml")

        let bundle = Bundle(for: type(of: self))
        guard let destUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("generated").appendingPathComponent("test") else {
            print("\(yamlFileName).yaml destUrl is nil")
            return false
        }

        if let sourceUrl = bundle.url(forResource: yamlFileName, withExtension: "yaml") {
            let manager = Manager(withInputUrl: sourceUrl, destinationUrl: destUrl)
            do {
                let (_, isMatchedConsistency) = try manager.loadModel()
                return isMatchedConsistency
            } catch {
                print(error)
                return false
            }
        } else {
            print("\(yamlFileName).yaml fails to load from bundle")
            return false
        }
    }

    static var allTests = [
        "testSwaggerFromTestServer"
    ]
}
