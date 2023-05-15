import Foundation
import ArgumentParser

extension Commands.Config {
    /// A command that runs the commands listed in the configuration file.
    struct Run: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "run",
            abstract: "Run commands listed in the configuration file."
        )

        /// An option group that provides the path to the configuration file to use.
        @OptionGroup
        var config: ConfigOptionGroup

        /// An option group that provides the path to the design token file to use.
        @OptionGroup
        var token: DesignTokenOptionGroup

        static let allParser = [
            AssetsCatalog.Parser.self.info,
            Files.Parser.self.info
        ]

        /// Runs the command.
        func run() throws {
            let token = try token.load()
            let configs = try config.load()

            try configs.forEach { config in
                try config.values.forEach { (key, value) in
                    guard let info = Self.allParser.parser(for: key) else {
                        print("Couldn't find a parser for key: \"\(key)\"")
                        return
                    }

                    let parser = try info.parseableType.init(config: value, token: token)
                    try parser.parse()
                }
            }
        }
    }
}
