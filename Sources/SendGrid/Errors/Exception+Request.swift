import Foundation

public extension Exception {
    /// The `Exception.Request` enum contains all the errors thrown by
    /// `Request`.
    enum Request: Error, CustomStringConvertible {
        // MARK: - Cases
        
        /// Thrown when there a request was made to encode the parameters to an
        /// unsupported content type.
        case unsupportedContentType(String)
        
        /// Thrown if there was a problem constructing the URL for the request
        /// call.
        case couldNotConstructUrlRequest
        
        // MARK: - Properties
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .unsupportedContentType(let type):
                return "Unsupported content type '\(type)': Unable to encode the request's parameters to type '\(type)'"
            case .couldNotConstructUrlRequest:
                return "There was a problem constructing the API call's URL. Please double check the `path` property for the request."
            }
        }
    }
}
