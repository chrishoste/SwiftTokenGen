import ArgumentParser
import Foundation

extension Commands.Templates {
    struct List: ParsableCommand {
        static let configuration = CommandConfiguration(
            commandName: "list",
            abstract: "Display all templates that are shipped by default."
        )

        /// Runs the command.
        func run() throws {
            guard let templates = Bundle.module.urls(forResourcesWithExtension: "stencil", subdirectory: nil) else {
                return
            }
            
            print("\n List of available templates: \n")
            for url in templates {
                print("    • \(url.lastPathComponent) - TODO<README>")
            }
        }
    }
}
