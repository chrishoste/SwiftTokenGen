import Foundation

extension URL {
    var camelCaseFileName: String {
        self
            .lastPathComponent
            .components(separatedBy: ".")
            .dropLast()
            .joined(separator: " ")
            .camelCase
    }
}
