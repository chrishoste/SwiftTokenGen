import Foundation

/// Represents an image with its name and URL.
struct Image {
    /// The name of the image.
    let name: String
    
    /// The URL of the image.
    let any: URL
    
    /// The file name of the image, including its extension.
    var file: String {
        name + ".\(any.pathExtension)"
    }
    
    /// The name of the imageset that contains the image.
    var imageset: String {
        name + ".imageset"
    }
    
    /**
     Initializes an `Image` instance with the specified name and URL.
     
     - Parameters:
       - name: The name of the image.
       - any: The URL of the image.
     */
    init(name: String, any: URL) {
        self.name = name
        self.any = any
    }
}
