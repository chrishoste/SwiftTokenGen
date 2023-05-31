import Foundation
import Stencil

/// A filter for converting values to quoted strings.
enum QuoteFilter {
    /**
     Filters a value and converts it to a quoted string if necessary.
     
     - Parameters:
       - value: The value to be filtered.
       - arguments: Any additional arguments for the filter (not used in this implementation).
       - context: The Stencil rendering context (not used in this implementation).
     
     - Returns: The filtered value, converted to a quoted string if necessary.
     */
    static func filter(value: Any?, arguments: [Any?], context: Context) throws -> Any? {
        guard let value else { return nil }
        
        if let boolValue = value as? Bool {
            return boolValue
        }

        if let numValue = value as? (any Numeric) {
            return numValue
        }

        if let strValue = value as? String {
            return "\"\(strValue)\""
        }

        return value
    }
}
