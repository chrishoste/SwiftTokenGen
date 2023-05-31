import Foundation

// A structure representing a configuration entry
struct ConfigEntry {
    // Retrieve an optional option value from a given dictionary for a specific key
    static func optionalOption<T>(from: Any?, for key: Key) -> T? {
        guard let dictionary = from as? [String: Any] else { return nil }

        return dictionary[key.rawValue] as? T
    }

    // Retrieve a required option value from a given dictionary for a specific key
    static func option<T>(from: Any?, for key: Key) throws -> T {
        guard let dictionary = from as? [String: Any] else {
            throw ConfigEntryError.failedToCastToDictionary
        }

        guard let option = dictionary[key.rawValue] as? T else {
            fatalError(key.errorMessage)
        }

        return option
    }
}

extension ConfigEntry {
    // A nested structure representing keys for configuration entries
    struct Key {
        var rawValue: String
        var errorMessage: String

        // Initialize a key with a raw value and an optional error message
        init(rawValue: String, errorMessage: String = "") {
            self.rawValue = rawValue
            self.errorMessage = errorMessage
        }
    }
}

extension ConfigEntry.Key {
    // Define keys for specific configuration parameters
    static var params = Self.init(rawValue: "params")
    static var inputs = Self.init(rawValue: "inputs")
    static var outputs = Self.init(rawValue: "outputs")
}

// An enumeration that represents an error encountered when parsing a configuration entry
private enum ConfigEntryError: Error, LocalizedError {
    case failedToCastToDictionary

    var errorDescription: String {
        switch self {
        case .failedToCastToDictionary:
            return "Config passed is not in the correct format"
        }
    }
}
