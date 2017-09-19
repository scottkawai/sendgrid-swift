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
    open static let shared: Session = Session()
    
    
    /// Default initializer.
    public init() {}
    
    
    /// Initiates an instance of SGSession with the given authentication method.
    ///
    /// - Parameter auth: The Authentication to use for the API call.
    public init(auth: Authentication) {
        self.authentication = auth
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
    /// Makes the HTTP request with the given `Request` object.
    ///
    /// - Parameters:
    ///   - request:            The `Request` instance to send.
    ///   - subuser:            Optional. The username of a subuser to make the request on behalf of.
    ///   - completionHandler:  A completion block taht will be called after the API call completes.
    open func send<ModelType>(request: Request<ModelType>, onBehalfOf subuser: String? = nil, completionHandler: @escaping (Response<ModelType>?) -> Void = { _ in }) throws {
        // Check that we have authentication set.
        guard let auth = self.authentication else { throw Exception.Session.authenticationMissing }
        
        try request.validate()
        
        // Get the NSURLRequest
        var payload = try request.generateUrlRequest()
        payload.addValue(auth.authorizationHeader, forHTTPHeaderField: "Authorization")
        if let sub = subuser { payload.addValue(sub, forHTTPHeaderField: "On-behalf-of") }
        
        // Make the HTTP request
        let task = self.urlSession.dataTask(with: payload) { (data, response, error) in
            let resp = Response<ModelType>(data: data, response: response, error: error, decodingStrategy: request.decodingStrategy)
            completionHandler(resp)
        }
        task.resume()
    }
}
