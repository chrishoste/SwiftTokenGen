import Foundation

enum L10n {
    enum Error {
        static let missingConfig = """
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
        
        static let missingToken = """
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
        
        static let missingAnyColor = """
            Error: The color value for the "any" variant is missing or in the wrong format.
            
            Please make sure the color value is provided as a valid string in the design token.
            Refer to the documentation for more information:
            [README.md](https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md)
            """
    }
}
