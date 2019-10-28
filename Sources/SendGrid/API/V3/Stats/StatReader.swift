import Foundation

/// The `StatReader` class is a base class that provides the core functionality
/// for all the stat API calls.
///
/// This class is inherited by all the stat requests, whereby each specifies it
/// parameter type.
public class StatReader<P: Encodable> {
    /// :nodoc:
    public let path: String
    
    /// :nodoc:
    public let method: HTTPMethod = .GET
    
    /// :nodoc:
    public var parameters: P
    
    /// :nodoc:
    public let encodingStrategy: EncodingStrategy
    
    /// :nodoc:
    public let decodingStrategy: DecodingStrategy
    
    // MARK: - Initialization
    
    /// Initializes the request with a path and set of parameters.
    ///
    /// - Parameters:
    ///   - path:       The path of the endpoint.
    ///   - parameters: The parameters used in the API call.
    internal init(path: String, parameters: P) {
        let format = "yyyy-MM-dd"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        self.path = path
        self.parameters = parameters
        self.encodingStrategy = EncodingStrategy(dates: .formatted(formatter), data: .base64)
        self.decodingStrategy = DecodingStrategy(dates: .formatted(formatter), data: .base64)
    }
}
