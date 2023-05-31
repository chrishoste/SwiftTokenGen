import XCTest
@testable import SwiftTokenGenCore

final class URLExtensionSpec: XCTestCase {
    let camelCaseSUT: [(String, String)] = [
        ("/path/to/file1.txt", "file1"),
        ("/path/to/file2.doc", "file2"),
        ("/path/to/file3.pdf", "file3"),
        ("/path/to/file4.jpg", "file4"),
        ("/path/to/file5.png", "file5"),
        ("/path/to/file6-with-dashes.txt", "file6WithDashes"),
        ("/path/to/file7_with_underscores.txt", "file7WithUnderscores"),
        ("/path/to/file8 with spaces.doc", "file8WithSpaces"),
        ("/path/to/file10 (1).jpg", "file10(1)"),
        ("/path/to/file11[1].png", "file11[1]"),
    ]
    
    func testCamelCaseStringExtension() throws {
        camelCaseSUT.forEach { (filePath, expectedFilename) in
            let file = URL(filePath: filePath)
            XCTAssertEqual(file.camelCaseFileName, expectedFilename)
        }
    }
}
