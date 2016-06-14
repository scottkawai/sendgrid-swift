//
//  Response.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/// A typealias encompassing the block method used for HTTP responses within the framework.
public typealias ResponseHandler = ((response: Response?, error: NSError?) -> Void)

/**
 
 The `Response` struct organizes and parses the HTTP responses returned from API calls.
 
 */
public class Response: HTTPMessage, CustomStringConvertible {
    
    // MARK: - Properties
    //=========================================================================
    /// The original Request that this response is associated with.
    public let request: Request
    
    /// The raw data from the HTTP response.
    public var data: NSData?
    
    /// The NSURLResponse returned from the NSURLSession.
    public let urlResponse: NSURLResponse?
    
    /// Information about the rate limiting on the request that was just made (if present).
    public var rateLimit: RateLimit?
    
    /// The `urlResponse` property as an NSHTTPURLResponse
    public var httpResponse: NSHTTPURLResponse? {
        return self.urlResponse as? NSHTTPURLResponse
    }
    
    /// The HTTP Method used on the original request.
    public var method: HTTPMethod { return self.request.method }
    
    /// The endpoint of the original request.
    public var endpoint: String { return self.request.endpoint }
    
    /// The HTTP status code abstracted from the urlResponse.
    public var statusCode: Int? {
        if let http = self.httpResponse {
            return http.statusCode
        }
        return nil
    }
    
    /// The headers of the response.
    public var messageHeaders: [String : String] {
        guard let http = self.httpResponse?.allHeaderFields as? [String:String] else { return [:] }
        return http
    }
    
    /// The content type of the response abstracted from the urlResponse.
    public var contentType: ContentType {
        guard let http = self.httpResponse,
            contentTypeHeader = http.allHeaderFields["Content-Type"] as? String
            else { return ContentType.PlainText }
        return ContentType(description: contentTypeHeader)
    }
    
    /// Returns the string representation of the `data` property, if able.
    public var stringValue: String? {
        guard let d = self.data else { return nil }
        return NSString(data: d, encoding: NSUTF8StringEncoding) as? String
    }
    
    /// Returns the JSON representation of the `data` property, if able.
    public var jsonValue: AnyObject? {
        guard let d = self.data else { return nil }
        return try? NSJSONSerialization.JSONObjectWithData(d, options: [])
    }
    
    /// Returns an API Blueprint of the response as a String.
    public var description: String {
        if let blueprint = APIBlueprint(response: self) { return blueprint.description }
        return ""
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the class with all the necessary properties.
     
     - parameter request:       The original request this response is for.
     - parameter data:          The body of the response.
     - parameter urlResponse    The NSURLResponse returned from the HTTP request.
     
     */
    public init(request: Request, data: NSData? = nil, urlResponse: NSURLResponse? = nil) {
        self.request = request
        self.data = data
        self.urlResponse = urlResponse
        self.rateLimit = RateLimit.rateLimitInfoFromUrlResponse(urlResponse)
    }
    
}