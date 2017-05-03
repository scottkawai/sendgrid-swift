//
//  Response.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Response` struct organizes and parses the HTTP responses returned from API calls.
 
 */
open class Response: HTTPMessage, CustomStringConvertible {
    
    // MARK: - Properties
    //=========================================================================
    /// The original Request that this response is associated with.
    open let request: Request
    
    /// The raw data from the HTTP response.
    open var data: Data?
    
    /// The NSURLResponse returned from the NSURLSession.
    open let urlResponse: URLResponse?
    
    /// Information about the rate limiting on the request that was just made (if present).
    open var rateLimit: RateLimit?
    
    /// The `urlResponse` property as an NSHTTPURLResponse
    open var httpResponse: HTTPURLResponse? {
        return self.urlResponse as? HTTPURLResponse
    }
    
    /// The HTTP Method used on the original request.
    open var method: HTTPMethod { return self.request.method }
    
    /// The endpoint of the original request.
    open var endpoint: String { return self.request.endpoint }
    
    /// The HTTP status code abstracted from the urlResponse.
    open var statusCode: Int? {
        guard let http = self.httpResponse else { return nil }
        return http.statusCode
    }
    
    /// The headers of the response.
    open var messageHeaders: [String : String] {
        guard let http = self.httpResponse?.allHeaderFields as? [String:String] else { return [:] }
        return http
    }
    
    /// The content type of the response abstracted from the urlResponse.
    open var contentType: ContentType {
        guard let http = self.httpResponse,
            let contentTypeHeader = http.allHeaderFields["Content-Type"] as? String
            else { return ContentType.plainText }
        return ContentType(description: contentTypeHeader)
    }
    
    /// Returns the string representation of the `data` property, if able.
    open var stringValue: String? {
        guard let d = self.data else { return nil }
        return String(data: d, encoding: .utf8)
    }
    
    /// Returns the JSON representation of the `data` property, if able.
    open var jsonValue: [AnyHashable:Any]? {
        guard let d = self.data else { return nil }
        return (try? JSONSerialization.jsonObject(with: d, options: [])) as? [AnyHashable:Any]
    }
    
    /// Returns an API Blueprint of the response as a String.
    open var description: String {
        guard let blueprint = APIBlueprint(response: self) else { return "" }
        return blueprint.description
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the class with all the necessary properties.
     
     - parameter request:       The original request this response is for.
     - parameter data:          The body of the response.
     - parameter urlResponse    The NSURLResponse returned from the HTTP request.
     
     */
    public init(request: Request, data: Data? = nil, urlResponse: URLResponse? = nil) {
        self.request = request
        self.data = data
        self.urlResponse = urlResponse
        self.rateLimit = RateLimit.rateLimitInfo(from: urlResponse)
    }
    
}
