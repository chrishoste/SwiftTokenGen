import XCTest
@testable import SwiftTokenGenCore

class TemplateErrorSpec: XCTestCase {
    func testTemplateErrors() throws {
        let path = "/path/to/template.stencil"
        XCTAssertEqual(TemplateError.invalidStencil(at: path).errorDescription, "Failed to read stencil file at path \(path)")
    }
}
