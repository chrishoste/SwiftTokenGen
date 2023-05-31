import Foundation

/// Represents a color with its name and variants (any and dark).
struct Color {
    let name: String
    let any: [String: Any]
    let dark: [String: Any]?
    
    /**
     Initializes a `Color` instance with the specified name and color values.
     
     - Parameters:
       - name: The name of the color.
       - any: The color value for the "any" variant.
       - dark: The color value for the "dark" variant (optional).
     */
    init(name: String, any: [String: Any], dark: [String: Any]?) {
        self.name = name
        self.any = any
        self.dark = dark
    }
    
    /**
     Initializes a `Color` instance with the specified name and design token entries.
     
     - Parameters:
       - name: The name of the color.
       - any: The design token entry for the "any" variant.
       - dark: The design token entry for the "dark" variant (optional).
     
     - Throws:
       - `Color.ColorError.missingAnyColor` if the color value for the "any" variant is missing or in the wrong format.
     */
    init(name: String, any: DesignToken.Entry, dark: DesignToken.Entry?) throws {
        guard let anyColor = any.value as? String else {
            throw ColorError.missingAnyColor
        }
        
        self.name = name
        self.any = ["hex": anyColor]
        
        if let darkColor = dark?.value as? String {
            self.dark = darkColor == anyColor ? nil : ["hex": darkColor]
        } else {
            self.dark = nil
        }
    }
}

// MARK: - Private Extensions

private extension Color {
    /// Errors that can occur during color initialization.
    enum ColorError: Error, LocalizedError {
        case missingAnyColor
        
        var errorDescription: String {
            switch self {
            case .missingAnyColor:
                return """
                Error: The color value for the "any" variant is missing or in the wrong format.
                
                Please make sure the color value is provided as a valid string in the design token.
                Refer to the documentation for more information:
                [README.md](https://github.com/chrishoste/SwiftTokenGen/blob/main/README.md)
                """
            }
        }
    }
}
