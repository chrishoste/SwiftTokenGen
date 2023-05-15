import ArgumentParser
import Foundation

@main
struct SwiftTokenGen: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "swift-token-gen",
        abstract: "A utility for generating code.",
        version: "0.1.0",
        subcommands: [
            Commands.Templates.self,
            Commands.Config.self
        ],
        defaultSubcommand: Commands.Config.self
    )
}

enum Commands {}
