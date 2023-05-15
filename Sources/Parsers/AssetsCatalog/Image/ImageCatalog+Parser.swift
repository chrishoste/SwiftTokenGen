import Foundation

// MARK: WORK IN PROGRESS

extension AssetsCatalog.Image {
    struct Parser: Parseable {
        private let config: Any
        private let token: DesignToken?

        init(config: Any, token: DesignToken? = nil) throws {
            self.config = config
            self.token = token
        }

        func parse() throws {
            debugPrint("-------- AssetsCatalog.Image --------")
            debugPrint("This feature is not yet implemented.")
            debugPrint("Stay tuned for future updates!")
        }
    }
}

extension AssetsCatalog.Image.Parser: ParserInfo {
    static var info: Parser.Info {
        .init(parseableType: AssetsCatalog.Image.Parser.self, name: "images")
    }
}
