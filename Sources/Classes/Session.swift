//
//  Session.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Session` class is used to faciliate the HTTP request to the SendGrid API endpoints.  When starting out, you'll want to configure `Session` with your authentication information, whether that be credentials or an API Key.  A class conforming to the `Resource` protocol is then used to provide information about the desired API call.
 
 You can also call the `sharedInstance` property of `Session` to get a singleton instance.  This will allow you to configure the singleton once, and continually reuse it later without the need to re-configure it.
 
 */
public class Session {
    
    // MARK: - Properties
    //=========================================================================
    /// The root URL for the API calls.
    var host: String = "https://api.sendgrid.com"
    
    /// This property holds the authentication information (credentials, or API Key) for the API requests via the `Authentication` enum.
    public var authentication: Authentication?
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     A shared singleton instance of SGSession.  Using the shared instance allows you to configure it once with the desired authentication method, and then continually reuse it without the need for re-configuration.
     
     */
    public class var sharedInstance : Session {
        struct Static {
            static let instance : Session = Session()
        }
        return Static.instance
    }
    
    
    /**
     
     Default initializer.
     
     */
    public init() {}
    
    
    /**
     
     Initiates an instance of SGSession with the given authentication method.
     
     - parameter auth: The SGAuthentication to use for the API call.
     
     */
    public init(auth: Authentication) {
        self.authentication = auth
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Makes the HTTP request with the given `Request` object.
     
     - parameter request:       An instance of `Request` or a subclass that represents the API call to be made.
     - parameter onBehalfOf:    The username of a subuser to make the request on behalf of.
     - parameter onComplete:    A completion handler to run after the HTTP request.
     
     */
    public func send(request: Request, onBehalfOf: String?, onComplete: ResponseHandler?) throws {
        // Check that we have authentication set.
        guard let _ = self.authentication else { throw Error.Session.AuthenticationMissing }
        
        try request.validate()
        
        // Get the NSURLRequest
        let payload = try request.requestForSession(self, onBehalfOf: onBehalfOf)
        
        // Make the HTTP request
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(payload) { (data, response, error) -> Void in
            if let block = onComplete {
                let resp = Response(request: request, data: data, urlResponse: response)
                block(response: resp, error: error)
            }
        }
        task.resume()
    }
    
    /**
     
     Makes the HTTP request with the given `Request` object.
     
     - parameter request:       An instance of `Request` or a subclass that represents the API call to be made.
     - parameter onComplete:    A completion handler to run after the HTTP request.
     
     */
    public func send(request: Request, onComplete: ResponseHandler? = nil) throws {
        try self.send(request, onBehalfOf: nil, onComplete: onComplete)
    }
}