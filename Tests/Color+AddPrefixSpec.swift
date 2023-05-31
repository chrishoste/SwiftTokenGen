import XCTest
@testable import SwiftTokenGenCore

class AssetsCatalogColorAddPrefixTests: XCTestCase {
    func testAssetsCatalogColorAddPrefix() {
        let colors: [Color] = [
            .init(name: "red", any: [:], dark: [:]),
            .init(name: "blue", any: [:], dark: [:]),
            .init(name: "green", any: [:], dark: [:]),
        ]
        
        let optionsWithPrefix = ["addPrefix": "prefix"]
        
        let prefixedColors = AssetsCatalog.Color.AddPrefix().process(colors, options: optionsWithPrefix)
        let nonPrefixedColors = AssetsCatalog.Color.AddPrefix().process(colors, options: nil)
        
        XCTAssertEqual(prefixedColors[0].name, "prefixRed")
        XCTAssertEqual(prefixedColors[1].name, "prefixBlue")
        XCTAssertEqual(prefixedColors[2].name, "prefixGreen")
        
        XCTAssertEqual(nonPrefixedColors[0].name, "red")
        XCTAssertEqual(nonPrefixedColors[1].name, "blue")
        XCTAssertEqual(nonPrefixedColors[2].name, "green")
    }
}
