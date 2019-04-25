import Foundation

public extension Exception {
    /// The `Exception.Authentication` enum contains all the errors thrown by
    /// `Authentication`.
    enum Authentication: Error, CustomStringConvertible {
        // MARK: - Cases
        
        /// Thrown when there was a problem encoding the username and password.
        case unableToEncodeCredentials
        
        // MARK: - Properties
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .unableToEncodeCredentials:
                return "There was a problem encoding the username and password for use in the Authorization header. Please double check them."
            }
        }
    }
}
