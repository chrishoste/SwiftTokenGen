import Foundation
import Yams

struct Config {
    let values: [String: Any]

    /**
     Initializes a new Config instance.
     
     The values are loaded from a YAML file located at the specified path.
     
     - Parameter path: The path to the YAML file.
     - Throws: An error if there is a problem reading or parsing the YAML file.
     */
    init(path: String) throws {
        let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        let configPath = pwd.appendingPathComponent(path)

        guard FileManager.default.fileExists(atPath: configPath.path) else {
            throw ConfigError.missingConfig
        }

        self.values = try Decoder.yaml(fromPath: configPath.path)
    }
}

private enum ConfigError: Error, LocalizedError {
    case missingConfig

    var errorDescription: String {
        switch self {
        case .missingConfig:
            return """
            Error: Missing Configuration

            The configuration was not provided or is in the wrong format.

            To provide the configuration, use one of the following options:

            Option 1: Command-line argument
            Use the '-c <config path>' or '-config <config path>' flag to specify the path to the configuration file.

            Example: SwiftTokenGen -c <config path>

            Option 2: File placement
            Put your configuration file named 'swift-token-gen.yml' into the folder where you are running the code generation.

            Make sure to provide a valid YAML file containing the configuration.

            For more information take a look at the documententation.
            (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]
            """
        }
    }
}
