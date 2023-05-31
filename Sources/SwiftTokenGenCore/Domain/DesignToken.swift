import AnyCodable
import Foundation

/// A struct representing a design token.
public struct DesignToken {
    let values: [String: Any]
    /**
    Initializes a design token with the given file path.
    - Parameter path: The file path of the design token.
    - Throws: `DesignTokenError.missingToken` if the token file doesn't exist.
    */
    public init(path: String) throws {
        guard FileManager.default.fileExists(atPath: path) else {
            throw DesignTokenError.missingToken
        }

        self.values = try Decoder.json(fromPath: path)
    }

    /**
     Retrieves the values for the given keys from the design token.
     - Parameters:
        - keys: The keys to retrieve the values for.
        - usePrefix: A flag indicating whether to use prefix for the value names.
     - Returns: An array of `Value` objects representing the retrieved values.
     - Throws: `DesignTokenError.failedToSubtoken` if a subtoken cannot be retrieved for the given keys.
     */
    func values(for keys: [String], usePrefix: Bool = false) throws -> [Value] {
        let dict = try subToken(for: keys)
        return try extractValues(from: dict, usePrefix: usePrefix)
    }
}

extension DesignToken {
    /// A struct representing an entry in the design token.
    struct Entry {
        let description: String?
        let type: String
        let value: Any
    }

    /// A struct representing a value in the design token.
    struct Value {
        let name: String
        let entry: Entry
    }
}

private extension DesignToken {
    /// A struct used for decoding the entry from the design token.
    struct EntryDecoder: Decodable {
        let description: String?
        let type: String
        let value: AnyDecodable

        /// Converts the decoded entry to a `DesignToken.Entry` object.
        var converted: DesignToken.Entry {
            guard let nestedValues = self.value.value as? [String: Any] else {
                return .init(description: description, type: type, value: value.value)
            }

            return .init(description: description, type: type, value: nestedValues)
        }
    }
}

private extension DesignToken {
    /**
     Retrieves a sub-token from a dictionary of values based on the given keys.
     - Parameters:
        - keys: An array of strings representing the keys to navigate the dictionary.
     - Returns: A dictionary containing the sub-token retrieved.
     - Throws: A `DesignTokenError` if the sub-token retrieval fails.
     */
    func subToken(for keys: [String]) throws -> [String: Any] {
        var currentDict = values

        for key in keys {
            // Check if the current value is a nested dictionary
            guard let nestedDict = currentDict[key] as? [String: Any] else {
                throw DesignTokenError.failedToSubtoken(keys: keys)
            }

            currentDict = nestedDict
        }

        return currentDict
    }
    
    /**
     Extracts the values from the given dictionary.
     - Parameters:
        - dict: The dictionary to extract values from.
     - prefix: The prefix to prepend to the value names.
     - usePrefix: A flag indicating whether to use prefix for the value names.
     - Returns: An array of `Value` objects representing the extracted values.
     */
    func extractValues(from dict: [String: Any], prefix: String = "", usePrefix: Bool = false) throws -> [Value] {
        var values: [Value] = []
        for (key, value) in dict {
            guard let nestedDict = value as? [String: Any] else { continue }
            let name = usePrefix ? "\(prefix + key.firstCharacterUppercased)".firstCharacterLowercased : key
            let data = try JSONSerialization.data(withJSONObject: nestedDict, options: [])

            if let entry = try? JSONDecoder().decode(DesignToken.EntryDecoder.self, from: data) {
                values.append(.init(name: name, entry: entry.converted))
            } else {
                values += try extractValues(from: nestedDict, prefix: name, usePrefix: usePrefix)
            }
        }

        return values
    }
}

enum DesignTokenError: Error, LocalizedError, Equatable {
    case missingToken
    case failedToSubtoken(keys: [String])

    var errorDescription: String {
        switch self {
        case .missingToken:
            return L10n.Error.missingToken
        case .failedToSubtoken(let keys):
            return "Failed to retrieve subtoken for keys: \(keys.joined(separator: ", "))"
        }
    }
}
