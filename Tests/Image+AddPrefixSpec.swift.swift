import XCTest
@testable import SwiftTokenGenCore

class AssetsCatalogImageAddPrefixTests: XCTestCase {
    func testAssetsCatalogImageAddPrefix() {
        let colors: [Image] = [
            .init(name: "lock", any: URL(filePath: "lock.svg"), dark: nil),
            .init(name: "profile", any: URL(filePath: "profile.svg"), dark: nil),
            .init(name: "settings", any: URL(filePath: "settings.svg"), dark: nil)
        ]
        
        let optionsWithPrefix = ["addPrefix": "prefix"]
        
        let prefixedColors = AssetsCatalog.Image.AddPrefix().process(colors, options: optionsWithPrefix)
        let nonPrefixedColors = AssetsCatalog.Image.AddPrefix().process(colors, options: nil)
        
        XCTAssertEqual(prefixedColors[0].name, "prefixLock")
        XCTAssertEqual(prefixedColors[1].name, "prefixProfile")
        XCTAssertEqual(prefixedColors[2].name, "prefixSettings")
        
        XCTAssertEqual(nonPrefixedColors[0].name, "lock")
        XCTAssertEqual(nonPrefixedColors[1].name, "profile")
        XCTAssertEqual(nonPrefixedColors[2].name, "settings")
    }
}
