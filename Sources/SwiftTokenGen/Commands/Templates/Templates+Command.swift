import ArgumentParser
import Foundation

/// Command-line tool to manage and run configuration files.
extension Commands {
    struct Templates: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "template",
            abstract: "Manage templates commands",
            subcommands: [
                List.self
            ],
            defaultSubcommand: List.self
        )
    }
}
