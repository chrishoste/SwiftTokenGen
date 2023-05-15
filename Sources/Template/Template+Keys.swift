import Foundation

extension Template {
    /// Enum of the keys that should be used in the stencil templates as context to render.
    enum ContextKeys: String {
        case params
        case inputs
        case values
    }
}
