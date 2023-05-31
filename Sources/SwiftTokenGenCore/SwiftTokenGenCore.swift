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
    
    
    
    public static func list() {
        guard let templates = Bundle.module.urls(forResourcesWithExtension: "stencil", subdirectory: nil) else {
            return
        }

        print("\n List of available templates: \n")
        for url in templates {
            print("    • \(url.lastPathComponent) - TODO<README>")
        }
    }
}
