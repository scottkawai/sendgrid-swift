import Foundation
#if os(Linux)
import FoundationNetworking
#endif

public extension Exception {
    /// The `Exception.APIResponse` struct represents the body returned from an
    /// API call that is indicating an error occurred.
    struct APIResponse: Error, Codable {
        /// The list of error messages.
        public let errors: [APIMessage]
        
        /// The original `HTTPURLResponse` from the HTTP request.
        public var httpResponse: HTTPURLResponse! { self._httpResponse }
        
        /// :nodoc:
        internal var _httpResponse: HTTPURLResponse!
        
        /// :nodoc:
        enum CodingKeys: String, CodingKey {
            case errors
        }
    }
    
    /// The `Exception.APIMessage` struct represents a single error that can be
    /// returned from the API.
    struct APIMessage: Codable {
        /// The description of the error.
        public let message: String
        
        /// The field in the request that the error is referencing.
        public let field: String?
        
        /// A description on how to solve the error.
        public let help: String?
    }
}
