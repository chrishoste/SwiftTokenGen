import Foundation

public enum SwiftTokenGenCore {
    static let allParser = [
        AssetsCatalog.Parser.self.info,
        Files.Parser.self.info
    ]
    
    public static func run(configs: [Config], designToken: DesignToken) throws {
        try configs.forEach { config in
            try config.values.forEach { (key, value) in
                guard let info = Self.allParser.parser(for: key) else {
                    print("Couldn't find a parser for key: \"\(key)\"")
                    return
                }

                let parser = try info.parseableType.init(config: value, token: designToken)
                try parser.parse()
            }
        }
    }
}
