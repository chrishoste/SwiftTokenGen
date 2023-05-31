import Foundation

extension String {
    /**
     Returns the string with the first character in lowercase.
     - Returns: The string with the first character in lowercase.
     */
    var firstCharacterLowercased: String {
        guard let firstChar = self.first else {
            return self
        }
        return firstChar.lowercased() + self.dropFirst()
    }

    /**
     Returns the string with the first character in uppercase.
     - Returns: The string with the first character in uppercase.
     */
    var firstCharacterUppercased: String {
        guard let firstChar = self.first else {
            return self
        }
        return firstChar.uppercased() + self.dropFirst()
    }

    /**
     Returns the string converted to camel case.
     
     The string is split into components based on the following delimiters: " ", "-", "_", "/", "\\", ".", ",".
     Each component is capitalized, except for the first one, which is in lowercase.
     Whitespace characters are removed.
     
     - Returns: The string converted to camel case.
     */
    var camelCase: String {
        var string = self

        [" ", "-", "_", "/", "\\", ".", ","].forEach {
            string = string
                .split(separator: $0)  // split to components
                .map { String($0).firstCharacterUppercased }
                .joined(separator: " ")
        }

        return string
            .removeWhitespace
            .firstCharacterLowercased
    }

    /**
     Returns the string with all whitespace characters removed.
     - Returns: The string with all whitespace characters removed.
     */
    var removeWhitespace: String {
        return replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
    }
}
