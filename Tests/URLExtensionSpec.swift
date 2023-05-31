import XCTest
@testable import SwiftTokenGenCore

final class URLExtensionSpec: XCTestCase {
    func testCamelCaseStringExtension() throws {
        let url = URL(filePath: "/test/hello-world.svg")
        
        XCTAssertEqual(url.camelCaseFileName, "helloWorld")
    }

}
