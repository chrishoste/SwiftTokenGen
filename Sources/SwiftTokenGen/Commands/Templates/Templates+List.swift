import ArgumentParser
import Foundation
import SwiftTokenGenCore

extension Commands.Templates {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "list",
            abstract: "Display all templates that are shipped by default."
        )

        /// Runs the command.
        func run() throws {
            // WIP
        }
    }
}
