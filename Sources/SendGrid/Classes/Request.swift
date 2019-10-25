import Foundation

/// The `Request` protocol should be used by any class that represents an API
/// request and sent through the `send` function in `Session`.
public protocol Request: CustomStringConvertible, Validatable {
    /// The type used for the request's parameters.
    associatedtype Parameters: Encodable
    
    /// The type returned from the API response.
    ///
    /// This is used to automatically convert the JSON response into the 
    /// specified type. If the API call doesn't return a response, then the 
    /// request should specify `Never` as it's `ResponseType`.
    associatedtype ResponseType: Decodable
    
    /// A `Bool` indicating if the request supports the "On-behalf-of" header.
    var supportsImpersonation: Bool { get }
    
    /// The HTTP verb to use in the call.
    var method: HTTPMethod { get }
    
    /// The headers to be included in the request.
    var headers: [String: String] { get }
    
    /// The decoding strategy.
    var decodingStrategy: DecodingStrategy { get }
    
    /// The encoding strategy.
    var encodingStrategy: EncodingStrategy { get }
    
    /// The path component of the API endpoint. This should start with a `/`,
    /// for example "/v3/mail/send".
    var path: String { get }
    
    /// The parameters that should be sent with the API call. These parameters
    /// will either be encoded into the body of the request or the query items
    /// of the request
    var parameters: Parameters? { get }
    
    /// Before a `Session` instance makes an API call, it will call this method
    /// to double check that the auth method it's about to use is supported by
    /// the endpoint. In general, this will always return `true`, however some
    /// endpoints, such as the mail send endpoint, only support API keys.
    ///
    /// - Parameter auth:   The `Authentication` instance that's about to be
    ///                     used.
    /// - Returns:          A `Bool` indicating if the authentication method is
    ///                     supported.
    func supports(auth: Authentication) -> Bool
}

public extension Request {
    /// The default implementation returns `true`.
    var supportsImpersonation: Bool { true }
    
    /// The default implementation includes `Content-Type` and `Accept` headers 
    /// specifying JSON.
    var headers: [String: String] {
        [
            "Content-Type": ContentType.json.description,
            "Accept": ContentType.json.description
        ]
    }
    
    /// The default strategy uses unix time and base 64 encoded data.
    var decodingStrategy: DecodingStrategy { DecodingStrategy() }
    
    /// The default strategy uses unix time and base 64 encoded data.
    var encodingStrategy: EncodingStrategy { EncodingStrategy() }
    
    /// The default implementation returns `true`.
    func supports(auth: Authentication) -> Bool { true }
    
    /// The default implementation validates the parameters, if validatable.
    func validate() throws {
        try (self.parameters as? Validatable)?.validate()
    }
    
    /// The default description returns an 
    /// [API Blueprint](https://apiblueprint.org/) of the request.
    var description: String {
        let path = self.path
        let parameterString: String?
        paramEncoding: do {
            if Parameters.self == Never.self {
                parameterString = nil
                break paramEncoding
            } else {
                guard let params = self.parameters else {
                    parameterString = nil
                    break paramEncoding
                }
                if self.method.hasBody {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = self.encodingStrategy.dates
                    encoder.dataEncodingStrategy = self.encodingStrategy.data
                    guard let data = try? encoder.encode(params) else {
                        parameterString = nil
                        break paramEncoding
                    }
                    parameterString = String(data: data, encoding: .utf8)
                } else {
                    let encoder = FormURLEncoder()
                    encoder.dateEncodingStrategy = self.encodingStrategy.dates
                    parameterString = try? encoder.stringEncode(params, percentEncoded: true)
                }
            }
        }
        var query: String {
            guard !self.method.hasBody, let q = parameterString, q.count > 0 else { return "" }
            return "?\(q)"
        }
        var requestTitle: String {
            let content = "+ Request"
            guard let contentType = self.headers["Content-Type"] else { return content }
            return content + " (\(contentType))"
        }
        var blueprint = """
        # \(self.method) \(path + query)
        
        \(requestTitle)
        
        
        """
        let formattedHeaders = self.headers.map { "            \($0.key): \($0.value)" }.sorted { $0 < $1 }
        if formattedHeaders.count > 0 {
            blueprint += """
                + Headers
            
            \(formattedHeaders.joined(separator: "\n"))
            
            """
        }
        if self.method.hasBody, let bodyString = parameterString {
            let indented = bodyString.split(separator: "\n").map { "            \($0)" }
            blueprint += """
            
                + Body
            
            \(indented.joined(separator: "\n"))
            
            """
        }
        return blueprint
    }
}

extension Never: Codable {
    /// :nodoc:
    public init(from decoder: Decoder) throws {
        fatalError("Attempted to decode to `Never`. There should have been an explicit check for this type to take a different action other than decoding.")
    }
    
    /// :nodoc:
    public func encode(to encoder: Encoder) throws {
        fatalError("Attempted to encode `Never`. There should have been an explicit check for this type to take a different action other than encoding.")
    }
}
