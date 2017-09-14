//
//  Request.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//
import Foundation

/// The `Request` class should be inherited by any class that represents an API
/// request and sent through the `send` function in `Session`.
///
/// This class contains a `ModelType` generic, which is used to map the API
/// response to a specific model that conforms to `Codable`.
open class Request<ModelType : Codable>: Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The HTTP verb to use in the call.
    open var method: HTTPMethod
    
    /// The parameters that should be sent with the API request.
    open var parameters: [AnyHashable:Any]?
    
    /// The Content-Type of the call.
    open var contentType: ContentType
    
    /// The Accept header value.
    open var acceptType: ContentType = .json
    
    /// The decoding strategy.
    open var decodingStrategy: DecodingStrategy = DecodingStrategy()
    
    /// The encoding strategy.
    open var encodingStrategy: EncodingStrategy = EncodingStrategy()
    
    /// An array representing the path portion of the request's API endpoint.
    /// For example, if the endpoint was the following:
    ///
    ///     https://api.sendgrid.com/v3/mail/send
    ///
    /// Then the value of this property would be:
    ///
    ///     ["v3", "mail", "send"]
    ///
    open var path: [String]
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - method:     The HTTP verb to use in the API call.
    ///   - parameters: Any parameters to send with the API call.
    ///   - path:       An array of strings representing the path of the
    ///                 endpoint.
    public init(method: HTTPMethod = .GET, contentType: ContentType = .formUrlEncoded, parameters: [AnyHashable : Any]? = nil, path: [String]) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.contentType = contentType
    }
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - method:     The HTTP verb to use in the API call.
    ///   - parameters: Any parameters to send with the API call.
    ///   - pathItems:  A list of strings representing the path of the endpoint.
    public convenience init(method: HTTPMethod = .GET, contentType: ContentType = .formUrlEncoded, parameters: [AnyHashable : Any]? = nil, pathItems: String...) {
        self.init(method: method, contentType: contentType, parameters: parameters, path: pathItems)
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /// Generates a `URLRequest` representation of the request.
    ///
    /// - Returns:  A `URLRequest` instance.
    /// - Throws:   Errors can be thrown if there was a problem encoding the
    ///             parameters or constructing the API URL endpoint.
    open func generateUrlRequest() throws -> URLRequest {
        var path = Constants.ApiHost + self.path.joined(separator: "/")
        var body: Data?
        if let params = self.parameters {
            if self.method.hasBody {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = self.encodingStrategy.dates
                encoder.dataEncodingStrategy = self.encodingStrategy.data
                body = try encoder.encode(params)
            } else {
                let query = params.map { URLQueryItem(name: "\($0.key)", value: "\($0.value)").description }
                path += "?" + query.joined(separator: "&")
            }
        }
        guard let url = URL(string: path) else {
            throw Exception.Request.couldNotConstructUrlRequest
        }
        var req = URLRequest(url: url)
        req.httpBody = body
        req.httpMethod = self.method.rawValue
        req.addValue(self.contentType.description, forHTTPHeaderField: "Content-Type")
        req.addValue(self.acceptType.description, forHTTPHeaderField: "Accept")
        return req
    }
    
    /// Validates that the content and accept types are valid.
    public func validate() throws {
        try self.contentType.validate()
        try self.acceptType.validate()
    }
    
    
    // MARK: - Deprecations
    //=========================================================================
    @available(*, unavailable, message: "use the `generateUrlRequest` method instead.")
    open func request(for session: Session, onBehalfOf: String?) throws -> URLRequest {
        throw Exception.Global.methodUnavailable(type(of: self), "request(for:onBehalfOf:)")
    }
    
}

