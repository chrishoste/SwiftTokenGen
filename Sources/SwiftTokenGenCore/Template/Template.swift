import Foundation
import Stencil

/// A utility for rendering templates using the Stencil template engine.
struct Template {
    private let fileManager: FileManager
    private let environment: Environment

    /// Initializes a new instance of `Template`.
    /// - Parameters:
    ///   - fileManager: The file manager to use for reading and writing files. Defaults to the default file manager.
    ///   - environment: The Stencil environment to use for rendering templates. Defaults to a new instance of `Environment`.
    init(fileManager: FileManager = .default) {
        let ext = Extension()
        ext.registerFilter("quote", filter: QuoteFilter.filter)
        
        self.fileManager = fileManager
        self.environment = Environment(extensions: [ext])
    }

    /// Renders a template with the given data and writes the output to a file.
    /// - Parameters:
    ///   - data: The data to use when rendering the template.
    ///   - templatePath: The path to the template file.
    ///   - filePath: The path to the output file.
    func render(data: [String: Any], with templatePath: String, to filePath: String) throws {
        let template = try readStencil(from: templatePath)
        let rendered = try renderTemplate(template, with: data)
        try writeRendered(rendered, to: filePath)
    }
}

private extension Template {
    /// Reads a Stencil template from a file.
    /// - Parameter filePath: The path to the template file.
    /// - Returns: The contents of the template file as a `String`.
    func readStencil(from filePath: String) throws -> String {
        let url = URL(fileURLWithPath: filePath)
        let templateData = try Data(contentsOf: url)
        guard let stencil = String(data: templateData, encoding: .utf8) else {
            throw TemplateError.invalidStencil(at: filePath)
        }
        return stencil
    }

    /// Renders a Stencil template with the given data.
    /// - Parameters:
    ///   - template: The template to render.
    ///   - data: The data to use when rendering the template.
    /// - Returns: The rendered output as a `String`.
    func renderTemplate(_ template: String, with data: [String: Any]) throws -> String {
        try environment.renderTemplate(string: template, context: data)
    }

    /// Writes rendered output to a file.
    /// - Parameters:
    ///   - rendered: The rendered output to write.
    ///   - filePath: The path to the output file.
    func writeRendered(_ rendered: String, to filePath: String) throws {
        let filePathURL = URL(fileURLWithPath: filePath)
        let directoryPath = filePathURL.deletingLastPathComponent().path

        try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        try rendered.write(to: filePathURL, atomically: false, encoding: .utf8)
    }
}
