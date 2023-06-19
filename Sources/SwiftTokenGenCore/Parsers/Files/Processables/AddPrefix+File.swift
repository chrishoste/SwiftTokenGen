import Foundation

extension Files {
    /**
     Adds a prefix to the names of the colors in the given processable array.
     The prefix is obtained from the options dictionary using the "addPrefix" key.
     If the "addPrefix" key is not present in the options, the processable array is returned unchanged.
     
     - Parameters:
       - processable: The array of colors to process.
       - options: The options dictionary containing the "addPrefix" key.
     
     - Returns: The array of colors with the added prefix in their names, if applicable.
     */
    struct AddPrefix: Processable {
        func process(_ processable: [DesignToken.Value], options: [String: Any]?) -> [DesignToken.Value] {
            guard let prefix: String = ConfigEntry.optionalOption(from: options, for: .addPrefix) else {
                return processable
            }
            
            return processable.map { value in
                    .init(name: prefix + value.name.firstCharacterUppercased, entry: value.entry)
            }
        }
    }
}

private extension ConfigEntry.Key {
    /// The configuration key for sorting.
    static let addPrefix = Self(rawValue: "addPrefix")
}
