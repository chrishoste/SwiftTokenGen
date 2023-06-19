import Foundation

extension AssetsCatalog.Color {
    /**
     Converts the color representation from hexadecimal to RGBA format for the given processable array.
     The color representation is obtained from the "hex" key in the color dictionary.
     If the "hex" key is not present or if the conversion fails, the color dictionary is returned unchanged.
     
     - Note: The function assumes that the "hex" key is a valid hexadecimal color representation.
     
     - Parameters:
       - processable: The array of colors to process.
       - options: The options dictionary (not used in this process).
     
     - Returns: The array of colors with the color representation converted to RGBA format.
     */
    struct HexToRGBA: Processable {
        func process(_ processable: [Color], options: [String: Any]?) -> [Color] {
            processable.map { color in
                guard let darkColor = color.dark else {
                    return .init(name: color.name, any: hexToRGBA(color: color.any), dark: nil)
                }
                
                return .init(name: color.name,
                             any: hexToRGBA(color: color.any),
                             dark: hexToRGBA(color: darkColor))
            }
        }
    }
}

// MARK: - Private Extensions

private extension AssetsCatalog.Color.HexToRGBA {
    /**
     Converts the color representation from hexadecimal to RGBA format.
     The hexadecimal color representation is obtained from the "hex" key in the color dictionary.
     If the "hex" key is not present or if the conversion fails, an empty dictionary is returned.
     
     - Note: The function assumes that the "hex" key is a valid hexadecimal color representation.
     
     - Parameter color: The color dictionary containing the "hex" key.
     
     - Returns: The color dictionary with the color representation converted to RGBA format.
     */
    func hexToRGBA(color: [String: Any]) -> [String: Any] {
        guard let hex = color["hex"] as? String else {
            return color
        }
        
        var newColor = color
        newColor["rgba"] = getComponents(from: hex)
        
        return newColor
    }
    
    /**
     Extracts the individual components (red, green, blue, alpha) from a hexadecimal color representation.
     
     - Parameter hexColor: The hexadecimal color representation.
     
     - Returns: A dictionary with the RGBA components extracted from the hexadecimal color representation.
     */
    func getComponents(from hexColor: String) -> [String: Any] {
        let startIndex = hexColor.index(hexColor.startIndex, offsetBy: 1)
    
        let red = String(hexColor[startIndex..<hexColor.index(startIndex, offsetBy: 2)])
        let green = String(hexColor[hexColor.index(startIndex, offsetBy: 2)..<hexColor.index(startIndex, offsetBy: 4)])
        let blue = String(hexColor[hexColor.index(startIndex, offsetBy: 4)..<hexColor.index(startIndex, offsetBy: 6)])
        
        return ["red": "0x" + red, "green": "0x" + green, "blue": "0x" + blue, "alpha": extractAlpha(from: hexColor), "hex": hexColor]
    }
    
    func extractAlpha(from hexColor: String) -> String {
        // Remove the '#' symbol from the hex color string
        var hex = hexColor
        if hex.hasPrefix("#") {
            hex.removeFirst()
        }
        
        // Check if the remaining hex string has a valid length
        guard hex.count == 8 else {
            return "1.000"
        }
        
        // Extract the alpha component from the hex string
        let alphaSubstring = hex.suffix(2)
        
        // Convert the alpha component to a decimal value
        guard let alphaValue = UInt8(alphaSubstring, radix: 16) else {
            return "1.000"
        }
        
        // Normalize the alpha value from 0-255 to 0.000-1.000
        let normalizedAlpha = Float(alphaValue) / 255.0
        
        // Format the normalized alpha value to three decimal places
        let formattedAlpha = String(format: "%.3f", normalizedAlpha)
        
        return formattedAlpha
    }
}
