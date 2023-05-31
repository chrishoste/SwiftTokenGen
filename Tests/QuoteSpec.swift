import XCTest
import Stencil
@testable import SwiftTokenGenCore

class QuoteFilterTests: XCTestCase {
    func testQuoteFilterOnNumber() throws {
        let number = 100
        let numberValue = try QuoteFilter.filter(value: number, arguments: [], context: .init())
        
        XCTAssertNotNil(numberValue)
        XCTAssertEqual(numberValue as! Int, number)
    }
    
    func testQuoteFilterBool() throws {
        let boolTrue = true
        let boolFalse = false
        
        let trueValue = try QuoteFilter.filter(value: boolTrue, arguments: [], context: .init())
        let falseValue = try QuoteFilter.filter(value: boolFalse, arguments: [], context: .init())
        
        XCTAssertTrue(trueValue as! Bool)
        XCTAssertFalse(falseValue as! Bool)
    }
    
    func testQuoteFilterString() throws {
        let string = "someStringValue"
        
        let quotedValue = try QuoteFilter.filter(value: string, arguments: [], context: .init())
        
        XCTAssertEqual(quotedValue as! String, "\"\(string)\"")
    }
    
    func testQuoteFilterOnNil() throws {
        let quotedValue = try QuoteFilter.filter(value: nil, arguments: [], context: .init())
        XCTAssertNil(quotedValue)
    }
    
    func testQuoteFilterNotSupportedValue() throws {
        let array = [1,2,3]
        let quotedArray = try QuoteFilter.filter(value: array, arguments: [], context: .init())
        
        XCTAssertEqual(array, quotedArray as! [Int])
    }
}

