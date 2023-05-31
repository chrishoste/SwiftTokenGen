import XCTest
@testable import SwiftTokenGenCore

class TemplateSpec: XCTestCase {
    
    var templatePath: URL!
    var outputDirectoryPath: URL { templatePath.deletingLastPathComponent().appendingPathComponent("Generated") }
    var outputPath: String { outputDirectoryPath.appendingPathComponent("test.txt").path }
        
    func testTemplate() throws {
        let stencil = "valid-stencil"
        templatePath = Bundle.module.url(forResource: stencil, withExtension: "stencil")!
        
        try Template().render(data: ["value" : "Hello World"], with: templatePath.path, to: outputPath)
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: outputPath))
        
        let url = URL(fileURLWithPath: outputPath)
        let outputData = try Data(contentsOf: url)
        let output = String(data: outputData, encoding: .utf8)
        
        XCTAssertNotNil(output)
        XCTAssertEqual(output, "Hello World")
        
        try deleteOutput()
    }
    
    func deleteOutput() throws {
        try FileManager.default.removeItem(at: outputDirectoryPath)
    }
}
