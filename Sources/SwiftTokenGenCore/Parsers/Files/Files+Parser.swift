import Foundation

/// Files represents a module that handles parsing and processing of files using a configuration and design token.
enum Files {}

/// The ParserInfo protocol defines the information required to identify a specific parser.
extension Files.Parser: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: Files.Parser.self, name: "files")
    }
}

extension Files {
    /// Parser is responsible for parsing and processing files using a configuration and design token.
    struct Parser: Parseable {
        private let files: [[String: Any]]
        private let token: DesignToken

        private let processor: Processor = .init(processables: [
            Files.AddPrefix(),
            Files.Sort()
        ])

        /**
         Initializes the Parser with a configuration and design token.
         
         - Parameters:
           - config: The configuration .
           - token: The design token or style dictionary.
         
         - Throws:
           - `ParserError.missingStyleDictionary` if the design token is missing.
           - `ParserError.missingConfig` if the configuration is missing or in the wrong format.
         */
        init(config: Any, token: DesignToken?) throws {
            guard let token else {
                throw ParserError.missingStyleDictionary
            }

            guard let config = config as? [[String: Any]] else {
                throw ParserError.missingConfig
            }

            self.token = token
            self.files = config
        }

        /**
         Parses and processes the files using the configuration and design token.
         
         - Throws:
           - Any parsing or processing errors encountered during the operation.
         */
        func parse() throws {
            for file in files {
                let context = try context(inputs: file[ConfigEntry.Key.inputs.rawValue])
                try template(outputs: file[ConfigEntry.Key.outputs.rawValue], context)
            }
        }

        /**
         The `context` function processes input data and returns a context dictionary.

         - Parameters:
            - inputs: The input data to be processed.

         - Throws:
            - `ParserError.invalidConfigEntry`: Thrown when the `inputs` parameter is not a valid configuration entry.

         - Returns: A dictionary containing the processed input values and parameters.

         - Note: This function assumes that the `inputs` parameter is an array of dictionaries, where each dictionary represents an input configuration.

         - Important: The `inputs` array should follow the specified format, or else an exception will be thrown.
         */
        private func context(inputs: Any?) throws -> [String: Any] {
            guard let inputs = inputs as? [[String: Any]] else {
                throw ParserError.invalidConfigEntry(key: ConfigEntry.Key.inputs.rawValue)
            }

            let values = try inputs.map { input in
                let keys: [String] = try ConfigEntry.option(from: input, for: .keys)
                let usePrefix: Bool = ConfigEntry.optionalOption(from: input, for: .keysAsNamePrefix) ?? false

                let values = try token.values(for: keys, usePrefix: usePrefix)
                let processedValues = processor.process(values, options: input)

                return [
                    Template.ContextKeys.values.rawValue: processedValues,
                    Template.ContextKeys.params.rawValue: input[ConfigEntry.Key.params.rawValue]
                ]
            }

            return [Template.ContextKeys.inputs.rawValue: values]
        }

        /**
         The `template` function renders output templates using the provided context.

         - Parameters:
            - outputs: The output configurations.
            - context: The context dictionary containing processed input values and parameters.

         - Throws:
            - `ParserError.invalidConfigEntry`: Thrown when the `outputs` parameter is not a valid configuration entry.
            - An error from the `Template.render` method if rendering fails.

         - Note: This function assumes that the `outputs` parameter is an array of dictionaries, where each dictionary represents an output configuration.

         - Important: The `outputs` array should follow the specified format, or else an exception will be thrown.
         */
        private func template(outputs: Any?, _ context: [String: Any]) throws {
            guard let outputs = outputs as? [[String: Any]] else {
                throw ParserError.invalidConfigEntry(key: ConfigEntry.Key.outputs.rawValue)
            }

            for output in outputs {
                let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)

                let templateRelativePath: String = try ConfigEntry.option(from: output, for: .template)
                let outputRelativePath: String = try ConfigEntry.option(from: output, for: .output)
                
                let templatePath = Bundle.module.url(forResource: templateRelativePath, withExtension: "stencil") ?? pwd.appendingPathComponent(templateRelativePath)
                let outputPath = pwd.appendingPathComponent(outputRelativePath)

                var context = context
                context[Template.ContextKeys.params.rawValue] = output[ConfigEntry.Key.params.rawValue]

                try Template().render(data: context, with: templatePath.path, to: outputPath.path)
            }
        }
    }
}

private extension ConfigEntry.Key {
    // Mandatory keys
    static let keys = Self.init(rawValue: "keys", errorMessage: """
        Error: Missing keys

        You need to provide key(s) from the DesignToken or Style Dictionary JSON
        in order to parse the desired values.

        To set up the configuration file, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'keys' to your input e.g:

        files:
          - outputs:
              - template: Templates/Grid.stencil
                output: Generated/DesignTokenGrid.swift
                params:
                  objectName: "DesignTokenGrid"
            inputs:
              - keys: [grid]
                params:
                  objectName: Phone
              - keys: [grid, tv]
                params:
                  objectName: TV

        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)

    static let template = Self.init(rawValue: "template", errorMessage: """
        Error: Missing template

        You need to provide a template for the output of the parsed values.

        To set up the template, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'template' to your ouput e.g:

        files:
          - outputs:
              - template: Templates/Grid.stencil
                output: Generated/DesignTokenGrid.swift
                params:
                  objectName: "DesignTokenGrid"
            inputs:
              - keys: [grid]
                params:
                  objectName: Phone
              - keys: [grid, tv]
                params:
                  objectName: TV

        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Note: If you choose to create your own template, make sure to use placeholders
        to indicate where the parsed values should be inserted. For example, you can use
        "{{color.primary}}" to represent the value of the "color.primary" key. You can also
        take a look at the predefined templates in the README.md as examples.

        Save the file and run the SPM CLI Tool again.
    """)

    static let output = Self.init(rawValue: "output", errorMessage: """
        Error: Missing output

        You need to provide an output path or at least a filename for the desired file.

        To set up the output, follow these steps:

        1. Open the configuration file `swift-token-gen.yaml` in the root directory
           of your project or at the provided path.

        2. Add 'output' to your ouput e.g:

        files:
          - outputs:
              - template: Templates/Grid.stencil
                output: Generated/DesignTokenGrid.swift
                params:
                  objectName: "DesignTokenGrid"
            inputs:
              - keys: [grid]
                params:
                  objectName: Phone
              - keys: [grid, tv]
                params:
                  objectName: TV


        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)

    // Optional keys
    static let keysAsNamePrefix = Self.init(rawValue: "keysAsNamePrefix")
}

private extension Files {
    enum ParserError: Error, LocalizedError {
        case missingStyleDictionary
        case missingConfig
        case invalidConfigEntry(key: String)

        var errorDescription: String {
            switch self {
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
