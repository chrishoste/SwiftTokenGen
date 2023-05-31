import Foundation
import ArgumentParser
import SwiftTokenGenCore

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
        var designToken: DesignTokenOptionGroup

        /// Runs the command.
        func run() throws {
            try SwiftTokenGenCore.run(configs: try config.load(),
                                      designToken: try designToken.load())
        }
    }
}
