import Foundation

public extension Exception {
    /// The `Exception.ContentType` enum contains all the errors thrown by
    /// `ContentType`.
    enum ContentType: Error, CustomStringConvertible {
        // MARK: - Cases
        
        /// Thrown when there was an invalid Content-Type used.
        case invalidContentType(String)
        
        // MARK: - Properties
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .invalidContentType(let type):
                return "Invalid content type '\(type)': Content types cannot contain ';', ',', spaces, or CLRF characters and must be at least 3 characters long."
            }
        }
    }
}
