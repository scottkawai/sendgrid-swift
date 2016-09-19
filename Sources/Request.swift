//
//  Request.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Request` protocol lays out the required properties and methods a class must implement in order to be used by `Session` to make an HTTP request.
 
 */
public protocol Request: HTTPMessage, CustomStringConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The Content-Type of what you're expecting back.
    var acceptType: ContentType { get }
    
    /// The parameters that should be sent with the API request.
    var parameters: [AnyHashable:Any]? { get }
    
    
    // MARK: - Methods
    //=========================================================================
    
    /**
     
     Returns a configured URLRequest with the proper authenticaiton information.
     
     - parameter session:       The session instance that will facilitate the HTTP request.
     - parameter onBehalfOf:    The username of a subuser to make the request on behalf of.
     
     - returns: A URLRequest with all the proper properties and authentication information set.
     
     */
    func request(for session: Session, onBehalfOf: String?) throws -> URLRequest
}

public extension Request {
    /// The default HTTP method is `GET`.
    public var method: HTTPMethod { return HTTPMethod.GET }
    
    /// The default Content-Type is `ContentType.FormUrlEncoded`.
    public var contentType: ContentType { return ContentType.formUrlEncoded }
    
    /// The default Accept type is `ContentType.JSON`.
    public var acceptType: ContentType { return ContentType.json }
    
    // MARK: - Miscellaneous
    //=========================================================================
    
    /// The default description uses `APIBlueprint` to generate an [API Blueprint](https://apiblueprint.org) output of the request.
    public var description: String {
        return APIBlueprint(request: self).description
    }
}
