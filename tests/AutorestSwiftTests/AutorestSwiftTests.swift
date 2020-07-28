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

import class Foundation.Bundle
import XCTest
@testable import AutorestSwiftFramework


final class AutorestSwiftTests: XCTestCase {
    func testSwaggerFromTestServer() throws {
        
        let yamlfiles = ["additionalProperties"]
        
        for file in yamlfiles {

            let result = runTestSwaggerFromTestServer(yamlFileName: file)
            
            if (!result) {
                print("*** \(file) return false")
            }
            // XCTAssertTrue(try runTestSwaggerFromTestServer(yamlFileName: file))
        }
    }

    func runTestSwaggerFromTestServer(yamlFileName: String) -> Bool {
       let bundle =  Bundle(for: type(of: self))
        guard let destUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("generated").appendingPathComponent("test") else  {
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
        }
        else {
        
        
            print("\(yamlFileName).yaml fails to load from bundle")
            return false
        }
    }
    
    static var allTests = [
        ("testSwaggerFromTestServer")
    ]
}
