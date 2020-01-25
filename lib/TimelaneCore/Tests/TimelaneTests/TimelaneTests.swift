import XCTest
@testable import TimelaneCore

final class TimelaneTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TimelaneCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
