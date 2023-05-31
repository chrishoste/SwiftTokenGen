import Foundation

/// Extension for AssetsCatalog.Color module.
extension AssetsCatalog.Color {
    /// Parser is responsible for parsing and processing colors into an asset catalog using a configuration and design token.
    struct Parser: Parseable {
        private let xcassets: [[String: Any]]
        private let token: DesignToken
        
        private let processor: Processor = .init(processables: [
            AssetsCatalog.Color.AddPrefix(),
            AssetsCatalog.Color.AddSuffix(),
            AssetsCatalog.Color.HexToRGBA()
        ])
        
        /**
         Initializes the Parser with a configuration and design token.
         
         - Parameters:
           - config: The configuration for the asset catalog.
           - token: The design token or style dictionary.
         
         - Throws:
           - `AssetsCatalog.Color.ParserError.missingConfig` if the configuration is missing or in the wrong format.
           - `AssetsCatalog.Color.ParserError.missingStyleDictionary` if the design token is missing.
         */
        init(config: Any, token: DesignToken?) throws {
            guard let config = config as? [[String: Any]] else {
                throw AssetsCatalog.Color.ParserError.missingConfig
            }
            
            guard let token else {
                throw AssetsCatalog.Color.ParserError.missingStyleDictionary
            }
            
            self.token = token
            self.xcassets = config
        }

        /**
         Parses and processes the colors in the asset catalog using the configuration and design token.
         
         - Throws:
           - Any parsing or processing errors encountered during the operation.
         */
        func parse() throws {
            try xcassets.forEach { options in
                let input: [String: Any] = try ConfigEntry.option(from: options, for: .input)
                let usePrefix: Bool = ConfigEntry.optionalOption(from: input, for: .keysAsNamePrefix) ?? false
                let anyValues = try values(for: input, usePrefix: usePrefix)
                
                let adaptive: [String: Any]? = ConfigEntry.optionalOption(from: options, for: .adaptive)
                let darkValues = try values(for: adaptive, usePrefix: usePrefix)
                
                let colors = try combineColors(anyValues, darkValues, adaptive: adaptive)
                let processedColors = processor.process(colors, options: options)
                
                try createAssetCatalog(config: options, colors: processedColors)
            }
        }
    }
}

// MARK: - Private Helper Methods

private extension AssetsCatalog.Color.Parser {
    /**
     Retrieves the design token values for the specified configuration entry.
     
     - Parameters:
       - configEntry: The configuration entry from which to retrieve the values.
       - usePrefix: Boolean value indicating whether to use prefixes for the token keys.
     
     - Throws:
       - Any errors encountered while retrieving the values.
     
     - Returns: An array of design token values.
     */
    func values(for configEntry: [String: Any]?, usePrefix: Bool) throws -> [DesignToken.Value] {
        guard let configEntry else { return [] }
        
        let inputKeys: [String] = try ConfigEntry.option(from: configEntry, for: .keys)
        return try token.values(for: inputKeys, usePrefix: usePrefix)
    }

    /**
     Combines the colors from "any" and "dark" variants into a single array of `Color` objects.
     
     - Parameters:
       - any: The color values for the "any" variant.
       - dark: The color values for the "dark" variant.
       - adaptive: The adaptive configuration.
     
     - Returns: An array of `Color` objects containing the combined color values.
     */
    func combineColors(_ any: [DesignToken.Value], _ dark: [DesignToken.Value], adaptive: [String: Any]?) throws -> [Color] {
        var darkDict = dark.reduce(into: [String: DesignToken.Value]()) {
            $0[$1.name] = $1
        }
        
        var colors: [Color] = try any.map { color in
            let darkValue = darkDict[color.name]?.entry
            darkDict.removeValue(forKey: color.name)
            return try .init(name: color.name, any: color.entry, dark: darkValue)
        }
        
        try darkDict.forEach { (key, value) in
            colors.append(try .init(name: key, any: value.entry, dark: nil))
        }
        
        return colors.sorted { $0.name < $1.name}
    }
    
    /**
     Creates the asset catalog for the given configuration and colors.
     
     - Parameters:
       - config: The configuration for the asset catalog.
       - colors: The processed colors to be added to the asset catalog.
     
     - Throws:
       - Any errors encountered while creating the asset catalog.
     */
    func createAssetCatalog(config: [String: Any], colors: [Color]) throws {
        let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        
        let output: String = try ConfigEntry.option(from: config, for: .output)
        let outputPath = pwd.appendingPathComponent(output)
        
        guard let templatePath = Bundle.module.url(forResource: Constants.infoContents, withExtension: Constants.stencil) else {
            throw AssetsCatalog.Color.ParserError.missingTemplate
        }
        
        try Template().render(data: [:], with: templatePath.path, to: outputPath.appendingPathComponent(Constants.contents).path)
        
        try colors.forEach { color in
            let context: [String: Any] = [
                Constants.params: config[Constants.params] ?? [],
                Constants.color: color
            ]
            
            guard let templatePath = Bundle.module.url(forResource: Constants.colorContents, withExtension: Constants.stencil) else {
                throw AssetsCatalog.Color.ParserError.missingTemplate
            }
            
            let colorsetOutputPath = outputPath.appendingPathComponent(color.name + Constants.colorset)
            try Template().render(data: context, with: templatePath.path, to: colorsetOutputPath.appendingPathComponent(Constants.contents).path)
        }
    }
}

// MARK: - ParserInfo

/// Extension to conform to the ParserInfo protocol and provide information about the parser.
extension AssetsCatalog.Color.Parser: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: AssetsCatalog.Color.Parser.self, name: "colors")
    }
}

private extension AssetsCatalog.Color.Parser {
    enum Constants {
        static var params = "params"
        static var color = "color"
        static var stencil = "stencil"
        static var contents = "Contents.json"
        static var colorset = ".colorset"
        
        static var colorContents = "color-contents"
        static var infoContents = "info-contents"
    }
}

private extension ConfigEntry.Key {
    // Mandatory keys
    static let output = Self.init(rawValue: "output", errorMessage: """
        Error: Missing output

        You need to provide an output path or at least a filename for the desired file.

        To set up the output, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'output' to your ouput e.g:

        xcassets:
          colors:
            - output: Generated/Colors.xcassets
              input:
                keys: [light, colors]
                keysAsNamePrefix: true
              adaptive:
                  keys: [dark, colors]


        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)
    
    static let input = Self.init(rawValue: "input", errorMessage: """
        Error: Missing input

        You need to provide an input.

        To set up the output, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'input' to your ouput e.g:

        xcassets:
          colors:
            - output: Generated/Colors.xcassets
              input:
                keys: [light, colors]
                keysAsNamePrefix: true
              adaptive:
                  keys: [dark, colors]


        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)
    
    static let keys = Self.init(rawValue: "keys", errorMessage: """
        Error: Missing keys

        You need to provide key(s) from the DesignToken or Style Dictionary JSON
        in order to parse the desired values.

        To set up the configuration file, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'keys' to your input e.g:

        xcassets:
          colors:
            - output: Generated/Colors.xcassets
              input:
                keys: [light, colors]
                keysAsNamePrefix: true
              adaptive:
                  keys: [dark, colors]

        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)
    
    // Optional keys
    static let adaptive = Self.init(rawValue: "adaptive")
    static let keysAsNamePrefix = Self.init(rawValue: "keysAsNamePrefix")
}


private extension AssetsCatalog.Color {
    enum ParserError: Error, LocalizedError {
        case missingStyleDictionary
        case missingConfig
        case missingTemplate
        case invalidConfigEntry(key: String)

        var errorDescription: String {
            switch self {
            case .missingTemplate:
                return """
                Error: Missing Template or Template not found
                
                For more information take a look at the documententation.
                (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]
                """
            
            case .missingStyleDictionary:
                return """
                Error: Missing Style Dictionary or Design Token

                No style dictionary or design token was provided.

                To provide the style dictionary or design token, use one of the following options:

                Option 1: Command-line argument
                Use the '-t <token path>' or '-token <token path>' flag to specify the path to the token file.

                Example: SwiftTokenGen -t <token path>

                Option 2: File placement
                Put your token file named 'token.json' into the folder where you are running the code generation.

                Make sure to provide a valid JSON file containing the style dictionary or design token.

                For more information take a look at the documententation.
                (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]
                """

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
