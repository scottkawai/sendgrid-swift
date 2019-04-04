import Foundation

/// The `Request` class should be inherited by any class that represents an API
/// request and sent through the `send` function in `Session`.
///
/// Only classes that aren't expecting any data back in the response should
/// directly inherit this class. If data is expected, then `ModeledRequest`
/// should be used instead.
open class Request<Parameters: Encodable>: Validatable {
    // MARK: - Properties
    
    /// A `Bool` indicating if the request supports the "On-behalf-of" header.
    open var supportsImpersonation: Bool { return true }
    
    /// The HTTP verb to use in the call.
    open var method: HTTPMethod
    
    /// The headers to be included in the request.
    open var headers: [String: String] = [
        "Content-Type": ContentType.json.description,
        "Accept": ContentType.json.description
    ]
    
    /// The decoding strategy.
    open var decodingStrategy: DecodingStrategy
    
    /// The encoding strategy.
    open var encodingStrategy: EncodingStrategy
    
    /// The path component of the API endpoint. This should start with a `/`,
    /// for example "/v3/mail/send".
    open var path: String
    
    /// The parameters that should be sent with the API call. These parameters
    /// will either be encoded into the body of the request or the query items
    /// of the request
    open var parameters: Parameters?
    
    // MARK: - Initialization
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - method:     The HTTP verb to use in the API call.
    ///   - parameters: Any parameters to send with the API call.
    ///   - path:       The path portion of the API endpoint, such as
    ///                 "/v3/mail/send". The path *must* start with a forward
    ///                 slash (`/`).
    ///   - parameters: Optional parameters to include in the API call.
    ///   - encoding:   The encoding strategy for the parameters.
    ///   - decoding:   The decoding strategy for the response.
    public init(method: HTTPMethod, path: String, parameters: Parameters? = nil, encodingStrategy: EncodingStrategy = EncodingStrategy(), decodingStrategy: DecodingStrategy = DecodingStrategy()) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.encodingStrategy = encodingStrategy
        self.decodingStrategy = decodingStrategy
    }
    
    // MARK: - Methods
    
    /// Retrieves a the value of a specific header, or `nil` if it doesn't
    /// exist.
    ///
    /// - Parameter name:   The name of the header to look for.
    /// - Returns:          The value, or `nil` if it doesn't exist.
    open func headerValue(named name: String) -> String? {
        var value: String?
        for entry in self.headers {
            if entry.key == name { value = entry.value }
        }
        return value
    }
    
    /// Validates that the content and accept types are valid.
    open func validate() throws {
        if let paramValidate = self.parameters as? Validatable {
            try paramValidate.validate()
        }
    }
    
    /// Before a `Session` instance makes an API call, it will call this method
    /// to double check that the auth method it's about to use is supported by
    /// the endpoint. In general, this will always return `true`, however some
    /// endpoints, such as the mail send endpoint, only support API keys.
    ///
    /// - Parameter auth:   The `Authentication` instance that's about to be
    ///                     used.
    /// - Returns:          A `Bool` indicating if the authentication method is
    ///                     supported.
    open func supports(auth: Authentication) -> Bool {
        return true
    }
}

/// The `ModeledRequest` class should be inherited by any class that represents
/// an API request and sent through the `send` function in `Session`.
///
/// This class contains a `ModelType` generic, which is used to map the API
/// response to a specific model that conforms to `Decodable`.
open class ModeledRequest<ModelType: Decodable, Parameters: Encodable>: Request<Parameters> {}

/// CustomStringConvertible conformance
extension Request: CustomStringConvertible {
    /// The description of the request, represented as an [API
    /// Blueprint](https://apiblueprint.org/)
    public var description: String {
        let path = self.path
        let parameterString: String?
        paramEncoding: do {
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
        var query: String {
            guard !self.method.hasBody, let q = parameterString, q.count > 0 else { return "" }
            return "?\(q)"
        }
        var requestTitle: String {
            let content = "+ Request"
            guard let contentType = self.headerValue(named: "Content-Type") else { return content }
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
