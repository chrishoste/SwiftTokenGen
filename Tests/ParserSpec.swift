import XCTest
@testable import SwiftTokenGenCore

class ParserSpec: XCTestCase {
    func testParseableObject() throws {
        let parserInfo = MockParsable.info
        
        XCTAssertEqual(parserInfo.name, "MockParser")
        XCTAssertTrue(parserInfo.parseableType is MockParsable.Type)
    }
    
    func testParseableCollection() throws {
        let parsers = [MockParsable.info]
        
        let parserInfo = parsers.parser(for: "MockParser")
        
        XCTAssertNotNil(parserInfo)
        XCTAssertEqual(parserInfo!.name, "MockParser")
        XCTAssertTrue(parserInfo!.parseableType is MockParsable.Type)
    }
    
    func testParseableParseFunction() throws {
        let parserInfo = MockParsable.info
        
        let parser = try parserInfo.parseableType.init(config: "", token: nil)
        try parser.parse()
        
        XCTAssertTrue((parser as! MockParsable).paseHasBeenCalled)
    }
}

// MARK: - Mocks

private class MockParsable: Parseable {
    var paseHasBeenCalled = false
    
    required init(config: Any, token: DesignToken?) throws {}
    
    func parse() throws {
        paseHasBeenCalled = true
    }
}

extension MockParsable: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: MockParsable.self, name: "MockParser")
    }
}
