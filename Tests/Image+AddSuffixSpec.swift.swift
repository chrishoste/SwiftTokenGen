import XCTest
@testable import SwiftTokenGenCore

class AssetsCatalogImageAddSuffixTests: XCTestCase {
    func testAssetsCatalogImageAddSuffix() {
        let colors: [Image] = [
            .init(name: "lock", any: URL(filePath: "lock.svg"), dark: nil),
            .init(name: "profile", any: URL(filePath: "profile.svg"), dark: nil),
            .init(name: "settings", any: URL(filePath: "settings.svg"), dark: nil)
        ]
        
        let optionsWithSuffix = ["addSuffix": "Suffix"]
        
        let suffixedColors = AssetsCatalog.Image.AddSuffix().process(colors, options: optionsWithSuffix)
        let nonSuffixedColors = AssetsCatalog.Image.AddSuffix().process(colors, options: nil)
        
        XCTAssertEqual(suffixedColors[0].name, "lockSuffix")
        XCTAssertEqual(suffixedColors[1].name, "profileSuffix")
        XCTAssertEqual(suffixedColors[2].name, "settingsSuffix")
        
        XCTAssertEqual(nonSuffixedColors[0].name, "lock")
        XCTAssertEqual(nonSuffixedColors[1].name, "profile")
        XCTAssertEqual(nonSuffixedColors[2].name, "settings")
    }
}
