import Foundation
import Yams

/// A utility class for decoding files of different types to dictionaries.
struct Decoder {
    /**
        Decodes a YAML file at the given path to a dictionary.
        - Parameter path: The path to the YAML file.
        - Throws: A `DecoderError` if decoding fails.
        - Returns: A dictionary representation of the YAML file.
    */
    static func yaml(fromPath path: String) throws -> [String: Any] {
        let fileContents = try String(contentsOfFile: path)
        let yamlData = try Yams.load(yaml: fileContents)
        guard let yamlDict = yamlData as? [String: Any] else {
            throw DecoderError.failedToDecodeYAML
        }
        return yamlDict
    }

    /**
        Decodes a JSON file at the given path to a dictionary.
        - Parameter path: The path to the JSON file.
        - Throws: A `DecoderError` if decoding fails.
        - Returns: A dictionary representation of the JSON file.
    */
    static func json(fromPath path: String) throws -> [String: Any] {
        let url = URL(fileURLWithPath: path)
        let jsonData = try Data(contentsOf: url, options: .mappedIfSafe)
        let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
        guard let jsonDict = json as? [String: Any] else {
            throw DecoderError.failedToDecodeJSON
        }
        return jsonDict
    }
}

/// An enum for decoder related errors.
enum DecoderError: Error, LocalizedError, Equatable {
    /// Error case for failure to decode a YAML file to a dictionary.
    case failedToDecodeYAML

    /// Error case for failure to decode a JSON file to a dictionary.
    case failedToDecodeJSON

    /// A human-readable error message.
    var errorDescription: String {
        switch self {
        case .failedToDecodeYAML:
            return "Failed to decode YAML file to [String: Any] dictionary"
        case .failedToDecodeJSON:
            return "Failed to decode JSON file to [String: Any] dictionary"
        }
    }
}
