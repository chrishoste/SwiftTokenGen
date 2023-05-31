import XCTest
@testable import SwiftTokenGenCore

class AssetsCatalogColorHexToRGBATests: XCTestCase {
    func testToRGBA() throws {
        let name = "background"
        let any: [String: Any] = ["hex": "#ffffffff"]
        let dark: [String: Any] = ["hex": "#000000ff"]
        
        let colors: [Color] = [
            .init(name: name, any: any, dark: dark),
            .init(name: name, any: any, dark: nil)
        ]
        
        let rgbaColors = AssetsCatalog.Color.HexToRGBA().process(colors, options: nil)
        
        XCTAssertEqual(rgbaColors[0].any["rgba"] as! [String: String], ["red": "0xff", "hex": "#ffffffff", "blue": "0xff", "green": "0xff", "alpha": "1.000"])
        XCTAssertEqual(rgbaColors[0].dark?["rgba"] as! [String: String], ["alpha": "1.000", "green": "0x00", "hex": "#000000ff", "blue": "0x00", "red": "0x00"])
        
        XCTAssertEqual(rgbaColors[1].any["rgba"] as! [String: String], ["red": "0xff", "hex": "#ffffffff", "blue": "0xff", "green": "0xff", "alpha": "1.000"])
        XCTAssertNil(rgbaColors[1].dark)
    }
    
    func testToRGBANoHexValue() throws {
        let name = "background"
        let any: [String: Any] = ["some": "#ffffffff"]
        
        let colors: [Color] = [
            .init(name: name, any: any, dark: nil)
        ]
        
        let rgbaColors = AssetsCatalog.Color.HexToRGBA().process(colors, options: nil)
                
        XCTAssertEqual(rgbaColors[0].any["some"] as! String, "#ffffffff")
        XCTAssertNil(rgbaColors[0].dark)
    }

}
