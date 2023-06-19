import Foundation
import Stencil

enum DashIfNeeded {
    static func filter(value: Any?, arguments: [Any?], context: Context) throws -> Any? {
        guard let value = value as? String, !value.isEmpty else { return nil }
        
        guard let firstCharacter = value.first, firstCharacter.isNumber else {
            return value
        }
        
        return "_" + value
    }
}

enum PrefixFilter {
    enum Font {
        static func filter(value: Any?, arguments: [Any?], context: Context) throws -> Any? {
            guard let value = value as? String else {
                return value
            }
            
            let possibleAmbiguities: Set<String> = ["largeTitle",
                                                    "title",
                                                    "title2",
                                                    "title3",
                                                    "headline",
                                                    "subheadline",
                                                    "body",
                                                    "callout",
                                                    "footnote",
                                                    "caption",
                                                    "caption2"]
            
            guard let prefix = arguments.first as? String, possibleAmbiguities.contains(value) else {
                return value
            }
            
            return prefix + value.firstCharacterUppercased
        }
    }
    
    enum Color {
        static func filter(value: Any?, arguments: [Any?], context: Context) throws -> Any? {
            guard let value = value as? String else {
                return value
            }
            
            let possibleAmbiguities: Set<String> = ["black",
                                                    "blue",
                                                    "brown",
                                                    "clear",
                                                    "cyan",
                                                    "gray",
                                                    "green",
                                                    "indigo",
                                                    "mint",
                                                    "orange",
                                                    "pink",
                                                    "purple",
                                                    "red",
                                                    "teal",
                                                    "white",
                                                    "yellow",
                                                    "accentColor",
                                                    "primary",
                                                    "secondary",
                                                    "description"]
            
            guard let prefix = arguments.first as? String, possibleAmbiguities.contains(value) else {
                return value
            }
            
            return prefix + value.firstCharacterUppercased
        }
    }
    
    enum UIImage {
        static func filter(value: Any?, arguments: [Any?], context: Context) throws -> Any? {
            guard let value = value as? String else {
                return value
            }
            
            let possibleAmbiguities: Set<String> = ["checkmark",
                                                    "add",
                                                    "remove",
                                                    "strokedCheckmark"]
            
            guard let prefix = arguments.first as? String, possibleAmbiguities.contains(value) else {
                return value
            }
            
            return prefix + value.firstCharacterUppercased
        }
    }
}
