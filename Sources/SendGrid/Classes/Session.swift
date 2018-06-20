//
//  Session.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/12/17.
//

import Foundation

/// The `Session` class is used to faciliate the HTTP request to the SendGrid
/// API endpoints.  When starting out, you'll want to configure `Session` with
/// your authentication information, whether that be credentials or an API Key.
/// A class conforming to the `Resource` protocol is then used to provide
/// information about the desired API call.
///
/// You can also call the `sharedInstance` property of `Session` to get a
/// singleton instance.  This will allow you to configure the singleton once,
/// and continually reuse it later without the need to re-configure it.
open class Session {
    
    // MARK: - Properties
    //=========================================================================
    
    /// This property holds the authentication information (credentials, or API
    /// Key) for the API requests via the `Authentication` enum.
    open var authentication: Authentication?
    
    /// If you're authenticating with a parent account, you can set this
    /// property to the username of a subuser. Doing so will authenticate with
    /// the parent account, but retrieve the information of the specified
    /// subuser, effectively impersonating them as though you had authenticated
    /// with the subuser's credentials.
    open var onBehalfOf: String?
    
    /// The `URLSession` to make the HTTPRequests with.
    #if os(Linux)
    let urlSession = URLSession(configuration: .default)
    #else
    let urlSession = URLSession.shared
    #endif
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// A shared singleton instance of SGSession.  Using the shared instance
    /// allows you to configure it once with the desired authentication method,
    /// and then continually reuse it without the need for re-configuration.
    public static let shared: Session = Session()
    
    
    /// Default initializer.
    public init() {}
    
    
    /// Initiates an instance of SGSession with the given authentication method.
    ///
    /// - Parameters:
    ///   - auth:       The Authentication to use for the API call.
    ///   - subuser:    A username of a subuser to impersonate.
    public init(auth: Authentication, onBehalfOf subuser: String? = nil) {
        self.authentication = auth
        self.onBehalfOf = subuser
    }
    
    #if os(Linux)
    /// Invalidates the `URLSession` on deinit.
    // deinit {
    /// FIX-ME: We whould really invalidate the URLSession here, but because
    /// it hasn't been implemented yet, we can't.
    /// https://github.com/apple/swift-corelibs-foundation/blob/master/Docs/Status.md
    
    // self.urlSession.invalidateAndCancel()
    // }
    #endif
    
    
    // MARK: - Methods
    //=========================================================================
    
    /// This method is the most generic method to make an API call with. It
    /// allows you to specify the individual properties of an API call and
    /// retrieve the raw response back. If you use this method, you'll most
    /// likely need to take the `Data` from the response and convert it into
    /// JSON (with something like `JSONSerialization` or `JSONDecoder`).
    ///
    /// - Parameters:
    ///   - path:               The path of the endpoint. This should not
    ///                         include the host. For example,
    ///                         "/v3/user/profile" (**note** the path must start
    ///                         with a `/`).
    ///   - method:             The HTTP method to make the API call with.
    ///   - parameters:         Optional parameters to include with the HTTP
    ///                         request.
    ///   - encodingStrategy:   The encoding strategy for any dates or data in
    ///                         the parameters.
    ///   - completionHandler:  A callback containing the response information.
    /// - Throws:               If there was a problem constructing or making
    ///                         the API call, an error will be thrown.
    open func request<T : Encodable>(path: String, method: HTTPMethod, parameters: T? = nil, encodingStrategy: EncodingStrategy = EncodingStrategy(), completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) throws {
        guard let auth = self.authentication else { throw Exception.Session.authenticationMissing }
        
        var components = URLComponents(string: Constants.ApiHost)
        components?.path = path
        let body: Data?
        if let params = parameters {
            if method.hasBody {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = encodingStrategy.dates
                encoder.dataEncodingStrategy = encodingStrategy.data
                body = try encoder.encode(params)
            } else {
                let encoder = FormURLEncoder()
                encoder.dateEncodingStrategy = encodingStrategy.dates
                components?.queryItems = try encoder.queryItemEncode(params)
                body = nil
            }
        } else {
            body = nil
        }
        guard let url = components?.url else {
            throw Exception.Request.couldNotConstructUrlRequest
        }
        
        var payload = URLRequest(url: url)
        payload.httpBody = body
        payload.addValue(auth.authorizationHeader, forHTTPHeaderField: "Authorization")
        payload.addValue("sendgrid/\(Constants.Version);swift", forHTTPHeaderField: "User-Agent")
        if let sub = self.onBehalfOf {
            payload.addValue(sub, forHTTPHeaderField: "On-behalf-of")
        }
        
        let task: URLSessionDataTask
        if let callback = completionHandler {
            task = self.urlSession.dataTask(with: payload, completionHandler: callback)
        } else {
            task = self.urlSession.dataTask(with: payload)
        }
        task.resume()
    }
    
    /// Makes the HTTP request with the given `Request` object.
    ///
    /// - Parameters:
    ///   - request:            The `Request` instance to send.
    ///   - subuser:            Optional. The username of a subuser to make the
    ///                         request on behalf of.
    ///   - completionHandler:  A completion block that will be called after the
    ///                         API call completes.
    open func send<ModelType>(request: Request<ModelType>, completionHandler: @escaping (Response<ModelType>?) -> Void = { _ in }) throws {
        // Check that we have authentication set.
        guard let auth = self.authentication else { throw Exception.Session.authenticationMissing }
        guard request.supports(auth: auth) else { throw Exception.Session.unsupportedAuthetication(auth.description) }
        
        try request.validate()
        
        // Get the NSURLRequest
        var payload = try request.generateUrlRequest()
        payload.addValue(auth.authorizationHeader, forHTTPHeaderField: "Authorization")
        payload.addValue("sendgrid/\(Constants.Version);swift", forHTTPHeaderField: "User-Agent")
        if let sub = self.onBehalfOf {
            if request.supportsImpersonation {
                payload.addValue(sub, forHTTPHeaderField: "On-behalf-of")
            } else {
                throw Exception.Session.impersonationNotAllowed
            }
        }
        
        // Make the HTTP request
        let task = self.urlSession.dataTask(with: payload) { (data, response, error) in
            let resp = Response<ModelType>(data: data, response: response, error: error, decodingStrategy: request.decodingStrategy)
            completionHandler(resp)
        }
        task.resume()
    }
}
