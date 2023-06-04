import Foundation

extension AssetsCatalog.Image {
    /**
     Adds a suffix to the names of the colors in the given processable array.
     The suffix is obtained from the options dictionary using the "addSuffix" key.
     If the "addSuffix" key is not present in the options, the processable array is returned unchanged.
     
     - Parameters:
       - processable: The array of colors to process.
       - options: The options dictionary containing the "addSuffix" key.
     
     - Returns: The array of colors with the added suffix in their names, if applicable.
     */
    struct AddSuffix: Processable {
        func process(_ processable: [Image], options: [String: Any]?) -> [Image] {
            guard let suffix: String = ConfigEntry.optionalOption(from: options, for: .addSuffix) else {
                return processable
            }
            
            return processable.map { image in
                .init(name: image.name + suffix,
                      any: image.any,
                      dark: image.dark)
            }
        }
    }
}

// MARK: - Private Extensions

private extension ConfigEntry.Key {
    /// The configuration key for sorting.
    static let addSuffix = Self.init(rawValue: "addSuffix")
}
