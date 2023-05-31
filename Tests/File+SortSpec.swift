import XCTest
@testable import SwiftTokenGenCore

class FileSortSpec: XCTestCase {
    func testFileProcessableSortNames() throws {
        let sortedValues = Files.Sort().process(MockData.namedSortValues, options: nil)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringArray)
    }
    
    func testFileProcessableSortValuesByName() throws {
        let sortBy = ["sortBy": "value"]
        let sortedValues = Files.Sort().process(MockData.namedSortValues, options: sortBy)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringArray)
    }
    
    func testFileProcessableSortValuesInt() throws {
        let sortBy = ["sortBy": "number"]
        let sortedValues = Files.Sort().process(MockData.numberValueSortValues, options: sortBy)
        let sortedSingleValues = Files.Sort().process(MockData.numberValueSortSingleValues, options: sortBy)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        let sortedSingleNames: [String] = sortedSingleValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringNumberArray.map { $0.0 })
        XCTAssertEqual(sortedSingleNames, MockData.stringNumberArray.map { $0.0 })
    }
    
    func testFileProcessableSortValuesText() throws {
        let sortBy = ["sortBy": "text"]
        let sortedValues = Files.Sort().process(MockData.stringValueSortValues, options: sortBy)
        let sortedSingleValues = Files.Sort().process(MockData.stringValueSortSingleValues, options: sortBy)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        let sortedSingleNames: [String] = sortedSingleValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringTextArray.map { $0.0 })
        XCTAssertEqual(sortedSingleNames, MockData.stringTextArray.map { $0.0 })
    }
    
    func testFileProcessableSortValuesDouble() throws {
        let sortBy = ["sortBy": "double"]
        let sortedValues = Files.Sort().process(MockData.doubleValueSortValues, options: sortBy)
        let sortedSingleValues = Files.Sort().process(MockData.doubleValueSortSingleValues, options: sortBy)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        let sortedSingleNames: [String] = sortedSingleValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringDoubleArray.map { $0.0 })
        XCTAssertEqual(sortedSingleNames, MockData.stringDoubleArray.map { $0.0 })
    }
    
    func testFileProcessableSortValuesBool() throws {
        let sortBy = ["sortBy": "bool"]
        let sortedValues = Files.Sort().process(MockData.boolValueSortValues, options: sortBy)
        let sortedSingleValues = Files.Sort().process(MockData.boolValueSortSingleValues, options: sortBy)
        
        let sortedNames: [String] = sortedValues.map { $0.name }
        let sortedSingleNames: [String] = sortedSingleValues.map { $0.name }
        
        XCTAssertEqual(sortedNames, MockData.stringBoolArray.map { $0.0 })
        XCTAssertEqual(sortedSingleNames, MockData.stringBoolArray.map { $0.0 })
    }
}

private extension FileSortSpec {
    enum MockData {
        static var stringArray = ["a", "b", "c", "d", "e", "f"]
        static var namedSortValues: [DesignToken.Value] {
            stringArray.shuffled().map { name in
                return .init(name: name, entry: .init(description: "", type: "", value: ["some": 2]))
            }
        }
        
        static var stringNumberArray = [("a", 1), ("b", 1), ("c", 2), ("d", 3), ("e", 4), ("f", 5)]
        static var numberValueSortValues: [DesignToken.Value] {
            stringNumberArray.shuffled().map { (name, number) in
                return .init(name: name, entry: .init(description: "", type: "", value: ["number": number]))
            }
        }
        
        static var numberValueSortSingleValues: [DesignToken.Value] {
            stringNumberArray.shuffled().map { (name, number) in
                return .init(name: name, entry: .init(description: "", type: "", value: number))
            }
        }
        
        static var stringDoubleArray = [("f", 1.0), ("e", 2.0), ("d", 3.0), ("c", 4.0), ("b", 5.0), ("a", 6.0)]
        static var doubleValueSortValues: [DesignToken.Value] {
            stringDoubleArray.shuffled().map { (name, double) in
                return .init(name: name, entry: .init(description: "", type: "", value: ["double": double]))
            }
        }
        
        static var doubleValueSortSingleValues: [DesignToken.Value] {
            stringDoubleArray.shuffled().map { (name, double) in
                return .init(name: name, entry: .init(description: "", type: "", value: double))
            }
        }
        
        static var stringTextArray = [("f", "a"), ("e", "b"), ("d", "c"), ("c", "d"), ("b", "e"), ("a", "f")]
        static var stringValueSortValues: [DesignToken.Value] {
            stringTextArray.shuffled().map { (name, text) in
                return .init(name: name, entry: .init(description: "", type: "", value: ["text": text]))
            }
        }
        
        static var stringValueSortSingleValues: [DesignToken.Value] {
            stringTextArray.shuffled().map { (name, text) in
                return .init(name: name, entry: .init(description: "", type: "", value: text))
            }
        }
        
        static var stringBoolArray = [("f", true), ("e", false), ("d", true), ("c", true), ("b", true), ("a", false)]
        static var boolValueSortValues: [DesignToken.Value] {
            stringBoolArray.map { (name, bool) in
                return .init(name: name, entry: .init(description: "", type: "", value: ["bool": bool]))
            }
        }
        
        static var boolValueSortSingleValues: [DesignToken.Value] {
            stringBoolArray.map { (name, bool) in
                return .init(name: name, entry: .init(description: "", type: "", value: bool))
            }
        }
    }
}
