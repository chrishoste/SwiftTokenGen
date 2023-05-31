import XCTest
@testable import SwiftTokenGenCore

class DomainDecoderTests: XCTestCase {
    func testDecoderError() throws {
        XCTAssertEqual(DecoderError.failedToDecodeYAML.errorDescription, "Failed to decode YAML file to [String: Any] dictionary")
        XCTAssertEqual(DecoderError.failedToDecodeJSON.errorDescription, "Failed to decode JSON file to [String: Any] dictionary")
    }
}
