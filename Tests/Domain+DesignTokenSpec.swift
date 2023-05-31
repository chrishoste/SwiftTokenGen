import XCTest
import Yams
@testable import SwiftTokenGenCore

final class DomainDesignTokenSpec: XCTestCase {
    func testValidToken() throws {
        let json = "valid-token"
        let tokenPath = Bundle.module.url(forResource: json, withExtension: "json")!
        
        let token = try DesignToken(path: tokenPath.path)
        
        XCTAssertNotNil(token.values["breakpoints"])
        XCTAssertNotNil(token.values["grid"])
    }
    
    func testTokenValidValues() throws {
        let json = "valid-token"
        let tokenPath = Bundle.module.url(forResource: json, withExtension: "json")!
        
        let token = try DesignToken(path: tokenPath.path)
        
        let color = try token.values(for: ["dark", "colors"], usePrefix: true)
        
        XCTAssertEqual(color.count, 2)
        XCTAssertTrue(color.contains { $0.name == "onBackgroundHighEmphasis" })
        XCTAssertTrue(color.contains { $0.name == "onBackgroundMediumEmphasis" })
    }
    
    func testTokenNameAsPrefix() throws {
        let json = "valid-token"
        let tokenPath = Bundle.module.url(forResource: json, withExtension: "json")!
        
        let token = try DesignToken(path: tokenPath.path)
        
        let breakpoints = try token.values(for: ["breakpoints"])
        let grid = try token.values(for: ["grid"])
        
        XCTAssertEqual(breakpoints.count, 7)
        XCTAssertEqual(grid.count, 8)
    }
    
    func testTokenNotValidValues() throws {
        let json = "valid-token"
        let tokenPath = Bundle.module.url(forResource: json, withExtension: "json")!
        
        let token = try DesignToken(path: tokenPath.path)
        
        XCTAssertThrowsError(try token.values(for: ["not"])) { error in
            XCTAssertTrue(error is DesignTokenError)
        }
    }

    func testNonValidToken() throws {
        let json = "not-valid-token"
        let tokenPath = Bundle.module.url(forResource: json, withExtension: "json")!
        
        XCTAssertThrowsError(try DesignToken(path: tokenPath.path)) { error in
            XCTAssertEqual(error as! DecoderError, DecoderError.failedToDecodeJSON)
        }
    }
    
    func testMissingTokenError() throws {
        XCTAssertThrowsError(try DesignToken(path: "")) { error in
            XCTAssertEqual(error as! DesignTokenError, DesignTokenError.missingToken)
        }
        
        XCTAssertEqual(DesignTokenError.missingToken.errorDescription, L10n.Error.missingToken)
    }
    
    func testFailedToSubtokenError() throws {
        XCTAssertEqual(DesignTokenError.failedToSubtoken(keys: ["Test"]).errorDescription,
                       "Failed to retrieve subtoken for keys: Test")
        XCTAssertEqual(DesignTokenError.failedToSubtoken(keys: ["Hello", "World"]).errorDescription,
                       "Failed to retrieve subtoken for keys: Hello, World")
    }
}
