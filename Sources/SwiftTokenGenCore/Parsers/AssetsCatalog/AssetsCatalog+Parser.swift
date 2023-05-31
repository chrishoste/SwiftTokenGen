import Foundation

/// A structure representing an assets catalog.
struct AssetsCatalog {
    /// A parser for assets catalog.
    struct Parser: Parseable {
        private let config: [String: Any]
        private let token: DesignToken?

        /// A list of all available parsers.
        static let parsers = [
            AssetsCatalog.Color.Parser.self.info,
            AssetsCatalog.Image.Parser.self.info
        ]

        /// Initializes the assets catalog parser.
        ///
        /// - Parameters:
        ///   - config: Configuration data for the parser.
        ///   - token: Optional design token.
        /// - Throws: ParserError.missingConfig if the configuration is missing or invalid.
        init(config: Any, token: DesignToken? = nil) throws {
            guard let config = config as? [String: Any] else {
                throw ParserError.missingConfig
            }

            self.config = config
            self.token = token
        }

        /// Parses the assets catalog.
        ///
        /// - Throws: ParserError.invalidConfigEntry if the configuration entry is invalid.
        func parse() throws {
            try config.forEach { (key, value) in
                guard let info = Self.parsers.parser(for: key) else {
                    throw ParserError.invalidConfigEntry(key: key)
                }

                let parser = try info.parseableType.init(config: value, token: token)
                try parser.parse()
            }
        }
    }
}

extension AssetsCatalog.Parser: ParserInfo {
    /// Parser information for assets catalog.
    static var info: Parser.Info {
        .init(parseableType: AssetsCatalog.Parser.self, name: "xcassets")
    }
}

extension AssetsCatalog {
    /// Substructure representing color assets.
    enum Color {}

    /// Substructure representing image assets.
    enum Image {}
}

private extension AssetsCatalog {
    enum ParserError: Error, LocalizedError {
        case missingConfig
        case invalidConfigEntry(key: String)

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

            case .invalidConfigEntry(let key):
                return """
                Error: Invalid Configuration Entry

                The configuration entry for key '\(key)' is missing or in the wrong format.

                Please check your configuration file and ensure that the entry for '\(key)' is present and correctly formatted.

                For more information take a look at the documententation.
                (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]
                """
            }
        }
    }
}
