import Foundation

/// # "Post"-Processor for parsed token values
/// Processor struct and a Processable protocol to process values that have been parsed previously.
/// This post-processing can modify or enhance values based on user-defined rules or configurations.

/// ## Processable
/// The Processable protocol defines a process method that takes a generic T object and an optional dictionary of options, and returns a modified T object.
/// The associated type T represents the type of object that the Processable can process.
/// Processable can be implemented to perform various operations on the T object, such as sorting, casting, modifying, or enhancing.

/// A protocol for types that can perform a process operation on an associatedtype
protocol Processable<T> {
    associatedtype T
    func process(_ processable: T, options: [String: Any]?) -> T
}

/// ## Processor
/// The Processor struct takes an array of Processable objects and applies them sequentially to the input values.
/// It has a process method that takes an initial value and an optional dictionary of options.
/// The method iterates through the processables array and applies each one to the input value, updating it as it goes.
/// The resulting value is then returned.

/// A struct that applies a sequence of Processable objects to an input object of an associatedtype
struct Processor<T> {
    let processables: [any Processable<T>]

    /**
     Processes the input object of the associatedtype by applying the sequence of processable objects to it
     
     - Parameters:
        - input: The input object the associatedtype to be processed
        - options: An optional dictionary of options that can be used by the Processable objects
     
     - Returns: The output object of the associatedtype after applying the sequence of Processable objects
     */
    func process(_ inital: T, options: Any?) -> T {
        let options: [String: Any]? = ConfigEntry.optionalOption(from: options, for: .process)

        var result = inital
        for processable in processables {
            result = processable.process(result, options: options)
        }
        return result
    }
}

/// An extension to the ConfigEntry.Key for the process option
private extension ConfigEntry.Key {
    static var process = Self.init(rawValue: "process")
}
