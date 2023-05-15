import Foundation
import Yams

/// A utility class for decoding files of different types to dictionaries.
struct Decoder {
    /**
        Decodes a given object to the specified type.
        - Parameters:
            - any: The object to decode.
            - type: The type to decode the object to.
        - Throws: A `DecoderError` if decoding fails.
        - Returns: The decoded object of the specified type.
    */
    static func decode<T: Decodable, U>(from any: Any, as type: U.Type) throws -> T {
        guard let anyObject = any as? U else {
            throw DecoderError.failedToDecodeAny(toType: "\(T.self)", asType: "\(U.self)")
        }

        let data = try JSONSerialization.data(withJSONObject: anyObject, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }

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
private enum DecoderError: Error, LocalizedError {
    /// Error case for failure to decode a YAML file to a dictionary.
    case failedToDecodeYAML

    /// Error case for failure to decode a JSON file to a dictionary.
    case failedToDecodeJSON

    /**
    Error case for failure to decode any object to the specified type.
    - Parameters:
        - toType: The type to which the object failed to decode.
        - asType: The type of the object being decoded.
    */
    case failedToDecodeAny(toType: String, asType: String)

    /// A human-readable error message.
    var errorDescription: String {
        switch self {
        case .failedToDecodeYAML:
            return "Failed to decode YAML file to [String: Any] dictionary"
        case .failedToDecodeJSON:
            return "Failed to decode JSON file to [String: Any] dictionary"
        case .failedToDecodeAny(let toType, let asType):
            return "Failed to decode \(asType) as \(toType)"
        }
    }
}
