import Foundation

enum Parser {}

/// Protocol for objects that can be parsed from a configuration and a design token.
protocol Parseable {
    init(config: Any, token: DesignToken?) throws
    func parse() throws
}

/// Protocol for parser types that can be created and used by the `Parser` object.
protocol ParserInfo: Parseable {
    /// Returns information about the parser.
    static var info: Parser.Info { get }
}

extension Parser {
    /// Provides information about a parser.
    struct Info {
        /// The type of the parser.
        let parseableType: Parseable.Type
        /// The name of the parser.
        public let name: String
    }
}

extension Collection where Element == Parser.Info {
    func parser(for name: String) -> Parser.Info? {
        first { $0.name == name }
    }
}
