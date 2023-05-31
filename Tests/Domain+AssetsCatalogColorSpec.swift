import XCTest
@testable import SwiftTokenGenCore

class ColorTests: XCTestCase {
    func testDifferentColorInit() throws {
        let name = "background"
        let any: DesignToken.Entry = .init(description: nil, type: "colo", value: "#ffffffff")
        let dark: DesignToken.Entry = .init(description: nil, type: "colo", value: "#000000ff")
        
        let color: Color = try .init(name: name, any: any, dark: dark)
        
        XCTAssertEqual(color.any["hex"] as! String, "#ffffffff")
        XCTAssertEqual(color.dark!["hex"] as! String, "#000000ff")
    }
    
    func testSameColorInit() throws {
        let name = "background"
        let any: DesignToken.Entry = .init(description: nil, type: "colo", value: "#ffffffff")
        let dark: DesignToken.Entry = .init(description: nil, type: "colo", value: "#ffffffff")
        
        let color: Color = try .init(name: name, any: any, dark: dark)
        
        XCTAssertEqual(color.any["hex"] as! String, "#ffffffff")
        XCTAssertNil(color.dark?["hex"] as? String)
    }
    
    func testOnlyAnyColorInit() throws {
        let name = "background"
        let any: DesignToken.Entry = .init(description: nil, type: "colo", value: "#ffffffff")
        
        let color: Color = try .init(name: name, any: any, dark: nil)
        
        XCTAssertEqual(color.any["hex"] as! String, "#ffffffff")
        XCTAssertNil(color.dark)
    }
    
    func testNoAnyColorInit() throws {
        let name = "background"
        let any: DesignToken.Entry = .init(description: nil, type: "colo", value: 100)
        
        XCTAssertThrowsError(try Color(name: name, any: any, dark: nil)) { error in
            XCTAssertTrue(error is ColorError)
            XCTAssertEqual(error as! ColorError, ColorError.missingAnyColor)
        }
    }
    
    func testMissingAnyColorErrorMessage() throws {
        XCTAssertEqual(ColorError.missingAnyColor.errorDescription, L10n.Error.missingAnyColor)
    }
}
