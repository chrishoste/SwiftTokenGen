import Foundation

/// An extension of `Files` that provides a `Sort` struct for processing an array of `DesignToken.Value` objects.
extension Files {
    /// A struct that conforms to the `Processable` protocol and provides a method for sorting an array of `DesignToken.Value` objects.
    struct Sort: Processable {
        /**
         Sorts an array of `DesignToken.Value` objects based on a given key.
         
         - Parameters:
           - processable: The array of `DesignToken.Value` objects to sort.
           - options: An optional dictionary of sorting options.
         - Returns: The sorted array of `DesignToken.Value` objects.
         */
        func process(_ processable: [DesignToken.Value], options: [String: Any]?) -> [DesignToken.Value] {
            let key: String? = ConfigEntry.optionalOption(from: options, for: .sortBy)
            return processable.sorted(by: key)
        }
    }
}

private extension ConfigEntry.Key {
    /// The configuration key for sorting.
    static let sortBy = Self.init(rawValue: "sortBy")
}

private extension Array where Element == DesignToken.Value {
    /**
     Sorts an array of `DesignToken.Value` objects based on a given key.
     
     - Parameter key: An optional key to sort the `DesignToken.Value` objects.
     - Returns: The sorted array of `DesignToken.Value` objects.
     */
    func sorted(by key: String?) -> [DesignToken.Value] {
        sorted { (lhs, rhs) in
            guard let key else { return lhs.name < rhs.name }

            switch (lhs.entry.value, rhs.entry.value) {
            case (let left as [String: Any], let right as [String: Any]):
                guard let leftValue = left[key], let rightValue = right[key] else { return lhs.name < rhs.name }
                guard !equal(leftValue, rhs: rightValue) else { return lhs.name < rhs.name }

                return compare(leftValue, rhs: rightValue)
            default:
                return compare(lhs.entry.value, rhs: rhs.entry.value)
            }
        }
    }

    /**
     Compares two values of any type.
     
     - Parameters:
       - lhs: The first value to compare.
       - rhs: The second value to compare.
     - Returns: A Boolean value indicating whether the first value is less than the second value.
     */
    func compare(_ lhs: Any, rhs: Any) -> Bool {
        switch (lhs, rhs) {
        case let (left as Int, right as Int):
            return left < right
        case let (left as String, right as String):
            return left < right
        case let (left as Double, right as Double):
            return left < right
        default:
            return false
        }
    }

    /**
     Determines whether two values of any type are equal.
     
     - Parameters:
       - lhs: The first value to compare.
       - rhs: The second value to compare.
     - Returns: A Boolean value indicating whether the two values are equal.
     */
    func equal(_ lhs: Any, rhs: Any) -> Bool {
        switch (lhs, rhs) {
        case let (left as Int, right as Int):
            return left == right
        case let (left as String, right as String):
            return left == right
        case let (left as Double, right as Double):
            return left == right
        default:
            return false
        }
    }
}
