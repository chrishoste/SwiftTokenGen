import Foundation

// MARK: WORK IN PROGRESS

extension AssetsCatalog.Color {
    struct Parser: Parseable {
        private let config: Any
        private let token: DesignToken?

        init(config: Any, token: DesignToken? = nil) throws {
            self.config = config
            self.token = token
        }

        func parse() throws {
            debugPrint("-------- AssetsCatalog.Color --------")
            debugPrint("This feature is not yet implemented.")
            debugPrint("Stay tuned for future updates!")
        }
    }
}

extension AssetsCatalog.Color.Parser: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: AssetsCatalog.Color.Parser.self, name: "colors")
    }
}
