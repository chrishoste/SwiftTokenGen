import XCTest
import Yams
@testable import SwiftTokenGenCore

final class DomainConfigSpec: XCTestCase {
    func testValidConfig() throws {
        let yml = "valid-config"
        let configPath = Bundle.module.url(forResource: yml, withExtension: "yml")!
        
        let config: Config = try .init(path: configPath.path)
        
        XCTAssertNotNil(config.values["files"])
    }
    
    func testNonValidConfig() throws {
        let yml = "not-valid-config"
        let configPath = Bundle.module.url(forResource: yml, withExtension: "yml")!
        
        XCTAssertThrowsError(try Config(path: configPath.path)) { error in
            XCTAssertEqual(error as! DecoderError, DecoderError.failedToDecodeYAML)
        }
    }
    
    func testMissingContig() {
        XCTAssertThrowsError(try Config(path: "")) { error in
            XCTAssertEqual(error as! ConfigError, ConfigError.missingConfig)
        }
        
        XCTAssertEqual(ConfigError.missingConfig.errorDescription, L10n.Error.missingConfig)
    }
}
