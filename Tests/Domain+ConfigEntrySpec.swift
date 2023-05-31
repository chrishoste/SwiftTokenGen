import XCTest
@testable import SwiftTokenGenCore

class DomainConfigEntryTests: XCTestCase {
    func testOptionalOptionConfigEntry() throws {
        let config: [String: Any] = [
            "params": 10,
            "inputs": "input_value",
            "outputs": true
        ]
        
        XCTAssertEqual(ConfigEntry.optionalOption(from: config, for: .params), 10)
        XCTAssertEqual(ConfigEntry.optionalOption(from: config, for: .inputs), "input_value")
        XCTAssertEqual(ConfigEntry.optionalOption(from: config, for: .outputs), true)
        
        let invalid: String? = ConfigEntry.optionalOption(from: config, for: .init(rawValue: "invalid"))
        let notDict: String? = ConfigEntry.optionalOption(from: "not_a_dictionary", for: .params)
        
        XCTAssertNil(invalid)
        XCTAssertNil(notDict)
    }
    
    func testOptionConfigEntry() throws {
        let config: [String: Any] = [
            "params": 10,
            "inputs": "input_value",
            "outputs": true
        ]
        
        XCTAssertEqual(try ConfigEntry.option(from: config, for: .params), 10)
        XCTAssertEqual(try ConfigEntry.option(from: config, for: .inputs), "input_value")
        XCTAssertEqual(try ConfigEntry.option(from: config, for: .outputs), true)
        
        XCTAssertThrowsError(try ConfigEntry.option(from: "not_a_dictionary", for: .params) as String) { error in
            XCTAssertEqual(error as? ConfigEntryError, .failedToCastToDictionary)
        }
        
        XCTAssertThrowsError(try ConfigEntry.option(from: config, for: .init(rawValue: "invalud_key", errorMessage: "some error")) as String) { error in
            XCTAssertEqual((error as NSError).domain, "some error")
        }
    }
    
    func testConfigEntryError() throws {
        XCTAssertEqual(ConfigEntryError.failedToCastToDictionary.errorDescription, "Config passed is not in the correct format")
    }
}
