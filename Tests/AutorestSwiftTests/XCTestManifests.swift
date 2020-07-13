import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(autorest_swiftTests.allTests),
    ]
}
#endif
