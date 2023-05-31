import Foundation
import Yams

public struct Config {
    let values: [String: Any]

    /**
     Initializes a new Config instance.
     
     The values are loaded from a YAML file located at the specified path.
     
     - Parameter path: The path to the YAML file.
     - Throws: An error if there is a problem reading or parsing the YAML file.
     */
    public init(path: String) throws {
        guard FileManager.default.fileExists(atPath: path) else {
            throw ConfigError.missingConfig
        }

        self.values = try Decoder.yaml(fromPath: path)
    }
}

enum ConfigError: Error, LocalizedError {
    case missingConfig

    var errorDescription: String {
        switch self {
        case .missingConfig: return L10n.Error.missingConfig
        }
    }
}
