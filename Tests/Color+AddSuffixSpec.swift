import XCTest
@testable import SwiftTokenGenCore

class AssetsCatalogColorAddSuffixTests: XCTestCase {
    func testAssetsCatalogColorAddSuffix() {
        let colors: [Color] = [
            .init(name: "red", any: [:], dark: [:]),
            .init(name: "blue", any: [:], dark: [:]),
            .init(name: "green", any: [:], dark: [:]),
        ]
        
        let optionsWithSuffix = ["addSuffix": "Suffix"]
        
        let suffixedColors = AssetsCatalog.Color.AddSuffix().process(colors, options: optionsWithSuffix)
        let nonSuffixedColors = AssetsCatalog.Color.AddSuffix().process(colors, options: nil)
        
        XCTAssertEqual(suffixedColors[0].name, "redSuffix")
        XCTAssertEqual(suffixedColors[1].name, "blueSuffix")
        XCTAssertEqual(suffixedColors[2].name, "greenSuffix")
        
        XCTAssertEqual(nonSuffixedColors[0].name, "red")
        XCTAssertEqual(nonSuffixedColors[1].name, "blue")
        XCTAssertEqual(nonSuffixedColors[2].name, "green")
    }
}
