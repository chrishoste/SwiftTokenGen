import Foundation

enum TemplateError: Error, LocalizedError {
    /// Error case for invalid stencil file path.
    /// - Parameter path: The invalid stencil file path.
    case invalidStencil(at: String)

    var errorDescription: String {
        switch self {
        case .invalidStencil(let path):
            return "Failed to read stencil file at path \(path)"
        }
    }
}
