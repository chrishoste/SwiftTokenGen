import ArgumentParser
import Foundation

/// Command-line tool to manage and run configuration files.
extension Commands {
    struct Config: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "config",
            abstract: "Manage and run configuration files.",
            subcommands: [
                Run.self
            ],
            defaultSubcommand: Run.self
        )
    }
}
