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
open class Request<ModelType : Codable> {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The HTTP verb to use in the call.
    open var method: HTTPMethod
    
    /// The parameters that should be sent with the API request.
    open var parameters: [AnyHashable:Any]?
    
    /// The Content-Type of the call.
    open var contentType: ContentType
    
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
    
    /// Provides the `parameters` property as `Data` encoded encording to the
    /// provided content type.
    ///
    /// - Parameter contentType:    The content type to encode the parameters
    ///                             with.
    /// - Returns: The encoded parameters, represented as `Data`.
    open func encodeParameters(with contentType: ContentType? = nil) throws -> Data? {
        guard let params = self.parameters else { return nil }
        let type = contentType ?? self.contentType
        switch type.subtype {
        case "json":
            return try JSONEncoder().encode(params)
        case "x-www-form-urlencoded":
            var components = URLComponents()
            components.queryItems = params.map { (key, value) -> URLQueryItem in
                return URLQueryItem(name: "\(key)", value: "\(value)")
            }
            return components.query?.data(using: .utf8)
        default:
            throw Exception.Request.unsupportedContentType(type.description)
        }
    }
    
    
    /// Generates the URL endpoint for a given host.
    ///
    /// - Parameter host: The host to build the endpoint off of.
    /// - Returns: A URL or `nil` if there was a problem.
    public func endpoint(for host: URL) throws -> URL? {
        guard var components = URLComponents(url: host, resolvingAgainstBaseURL: false)
            else { throw Exception.Request.couldNotConstructUrlRequest }
        components.path = "/" + self.path.joined(separator: "/")
        if !self.method.hasBody, let queryData = try self.encodeParameters(with: .formUrlEncoded) {
            components.query = String(data: queryData, encoding: .utf8)
        }
        return components.url
    }
    
    
}

