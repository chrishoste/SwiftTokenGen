import XCTest
@testable import SwiftTokenGenCore

class ProcessorSpec: XCTestCase {
    func testProcessor() throws {
        let values = [10, 10, 20, -5, 2]
        let processables = values.map { IntProcessable(value: $0) }
        
        let processor: Processor = .init(processables: processables)
        let processedValue = processor.process(0, options: nil)
        
        XCTAssertEqual(processedValue, values.reduce(0, +))
    }
}

private struct IntProcessable: Processable {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    func process(_ processable: Int, options: [String : Any]?) -> Int {
        return processable + value
    }
}
