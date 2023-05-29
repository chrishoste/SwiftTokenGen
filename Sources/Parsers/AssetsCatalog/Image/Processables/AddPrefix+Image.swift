import Foundation

extension AssetsCatalog.Image {
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
        func process(_ processable: [Image], options: [String: Any]?) -> [Image] {
            guard let prefix: String = ConfigEntry.optionalOption(from: options, for: .addPrefix) else {
                return processable
            }
            
            return processable.map { image in
                .init(name: prefix + image.name.firstCharacterUppercased,
                      any: image.any)
            }
        }
    }
}

// MARK: - Private Extensions

private extension ConfigEntry.Key {
    /// The configuration key for adding a prefix to color names.
    static let addPrefix = Self(rawValue: "addPrefix")
}
