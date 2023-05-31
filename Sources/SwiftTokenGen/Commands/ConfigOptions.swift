import Foundation
import ArgumentParser
import SwiftTokenGenCore

extension Commands.Config {
    /// A group of options related to the configuration file.
    struct ConfigOptionGroup: ParsableArguments {
        /// The path to the configuration file.
        @Option(
            name: [.customLong("config"), .customShort("c")],
            parsing: .upToNextOption,
            help: "Path to the configuration file to use"
        )
        var configs: [String] = ["swift-token-gen.yml"]

        /**
         Loads a `Config` instance from the configuration file.
         
         - Returns: A `Config` instance loaded from the file.
         - Throws: An error if the file cannot be loaded or parsed.
         */
        func load() throws -> [Config] {
            let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            return try configs.map { try .init(path: pwd.appendingPathComponent($0).path) }
        }
    }

    /// A group of options related to the design token file.
    struct DesignTokenOptionGroup: ParsableArguments {
        /// The path to the design token file.
        @Option(
            name: [.customLong("token"), .customShort("t")],
            help: "Path to the design token file to use",
            completion: .file(extensions: ["json"])
        )
        var file: String = "token.json"

        /**
         Loads a `DesignToken` instance from the design token file.
         
         - Returns: A `DesignToken` instance loaded from the file.
         - Throws: An error if the file cannot be loaded or parsed.
         */
        func load() throws -> DesignToken {
            let pwd = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
            return try .init(path: pwd.appendingPathComponent(file).path)
        }
    }
}
