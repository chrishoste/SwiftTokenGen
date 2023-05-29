import Foundation

extension AssetsCatalog.Image {
    /// A parser for handling image assets in an asset catalog.
    struct Parser: Parseable {
        private let xcassets: [[String: Any]]
        private let token: DesignToken?
        
        private let processor: Processor = .init(processables: [
            AssetsCatalog.Image.AddPrefix(),
            AssetsCatalog.Image.AddSuffix()
        ])

        /**
         Initializes an `AssetsCatalog.Image.Parser` instance with the specified configuration and optional design token.
         
         - Parameters:
           - config: The configuration for parsing image assets.
           - token: An optional design token to apply during parsing.
         
         - Throws:
           - `AssetsCatalog.Image.ParserError.missingConfig` if the configuration is missing or in the wrong format.
         */
        init(config: Any, token: DesignToken? = nil) throws {
            guard let config = config as? [[String: Any]] else {
                throw AssetsCatalog.Image.ParserError.missingConfig
            }
                        
            self.xcassets = config
            self.token = token
        }

        /**
         Parses the image assets based on the provided configuration.
         
         - Throws: Any parsing or file-related errors that occur during the parsing process.
         */
        func parse() throws {
            try xcassets.forEach { options in
                let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                
                let output: String = try ConfigEntry.option(from: options, for: .output)
                let outputPath = pwd.appendingPathComponent(output)
                
                let input: String = try ConfigEntry.option(from: options, for: .input)
                let inputPath = pwd.appendingPathComponent(input)
                
                let urls = try FileManager.default.contentsOfDirectory(at: inputPath, includingPropertiesForKeys: nil)
                let images = urls.map { Image(name: $0.fileName, any: $0) }
                let processedImage = processor.process(images, options: options)
                
                try createAssetCatalog(images: processedImage, outputPath: outputPath, options: options)
            }
        }
                
        /**
         Creates an asset catalog with the processed images at the specified output path.
         
         - Parameters:
           - images: The processed images to include in the asset catalog.
           - outputPath: The output path where the asset catalog will be created.
           - options: Additional options for the asset catalog creation.
         
         - Throws:
           - `AssetsCatalog.Image.ParserError.missingTemplate(templateName:)` if a required template for the asset catalog creation is missing.
           - Any file-related errors that occur during the asset catalog creation process.
         */
        func createAssetCatalog(images: [Image], outputPath: URL, options: [String: Any]) throws{
            guard let templatePath = Bundle.module.url(forResource: Constants.infoContents, withExtension: Constants.stencil) else {
                throw ParserError.missingTemplate(templateName: Constants.infoContents)
            }
            
            try Template().render(data: [:], with: templatePath.path, to: outputPath.appendingPathComponent(Constants.contents).path)
            
            for image in images {
                let imagesetOutputPath = outputPath.appendingPathComponent(image.imageset)
                let imageOutputPath = imagesetOutputPath.appendingPathComponent(image.file)
                
                guard let templatePath = Bundle.module.url(forResource: Constants.imageContents, withExtension: Constants.stencil) else {
                    throw ParserError.missingTemplate(templateName: Constants.imageContents)
                }
                
                if FileManager.default.fileExists(atPath: imageOutputPath.path) {
                    try FileManager.default.removeItem(at: imageOutputPath)
                }
                
                let context = [
                    Constants.file: image.file,
                    Constants.params: options[Constants.params] ?? [],
                    Constants.properties: options[Constants.properties] ?? []
                ]
                
                try Template().render(data: context, with: templatePath.path, to: imagesetOutputPath.appendingPathComponent(Constants.contents).path)
                try FileManager.default.copyItem(at: image.any, to: imageOutputPath)
            }
        }
    }
}

extension AssetsCatalog.Image.Parser: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: AssetsCatalog.Image.Parser.self, name: "images")
    }
}

private extension AssetsCatalog.Image.Parser {
    enum Constants {
        static var params = "params"
        static var properties = "properties"
        static var file = "file"
        
        static var contents = "Contents.json"
        
        static var stencil = "stencil"
        static var imageContents = "image-contents"
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
          images:
            - output: Generated/Icons.xcassets
              input: Images/icons
              properties:
                preserves-vector-representation: true
                template-rendering-intent: template


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
          images:
            - output: Generated/Icons.xcassets
              input: Images/icons
              properties:
                preserves-vector-representation: true
                template-rendering-intent: template


        3. For more information take a look at the documententation.
        (README.md)[https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md]

        Save the file and run the SPM CLI Tool again.
    """)
}

private extension AssetsCatalog.Image {
    enum ParserError: Error, LocalizedError {
        case missingConfig
        case missingTemplate(templateName: String)
        case invalidConfigEntry(key: String)

        var errorDescription: String {
            switch self {
            case .missingTemplate(let template):
                return """
                Error: Missing Template or Template not found
                
                Could not find a template named \(template)
                
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
