import XCTest
@testable import SwiftTokenGenCore

class ImageTests: XCTestCase {
    func testImageProperties() {
        let imageURL = URL(string: "https://example.com/image.png")!
        let imageName = "image"
        
        let image = Image(name: imageName, any: imageURL, dark: nil)
        
        XCTAssertEqual(image.name, imageName)
        XCTAssertEqual(image.any, imageURL)
        XCTAssertEqual(image.file, "image.png")
        XCTAssertEqual(image.imageset, "image.imageset")
    }
    
    func testImagePropertiesWithDash() {
        let imageURL = URL(string: "https://example.com/hello-world-01.svg")!
        let imageName = "helloWorld01"
        
        let image = Image(name: imageName, any: imageURL, dark: nil)
        
        XCTAssertEqual(image.name, imageName)
        XCTAssertEqual(image.any, imageURL)
        XCTAssertEqual(image.file, "helloWorld01.svg")
        XCTAssertEqual(image.imageset, "helloWorld01.imageset")
    }
}
