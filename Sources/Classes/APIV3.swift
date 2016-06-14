//
//  APIV3.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `APIV3` class is inherited by other classes to provide default implementations of the `Request` protocol.
 
 */
public class APIV3 {
    
    // MARK: - Properties
    //=========================================================================
    /// Additional headers to add to the HTTP request.
    public var messageHeaders: [String:String] {
        guard let resource = self as? Request else {
            return [:]
        }
        return [
            "Accept": resource.acceptType.description,
            "Content-Type": resource.contentType.description
        ]
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Returns a configured NSMutableURLRequest with the proper authenticaiton information.
     
     - parameter session:       The session instance that will facilitate the HTTP request.
     - parameter onBehalfOf:    The username of a subuser to make the request on behalf of.
     
     - returns: A NSMutableURLRequest with all the proper properties and authentication information set.
     
     */
    public func requestForSession(session: Session, onBehalfOf: String?) throws -> NSMutableURLRequest {
        guard let resource = self as? Request else { throw Error.Request.NonConformingRequest(self.dynamicType) }
        
        guard let location = NSURL(string: session.host)?.URLByAppendingPathComponent(resource.endpoint) else { throw Error.Request.UnableToConstructUrl }
        let request = NSMutableURLRequest(URL: location)
        
        for (key, value) in resource.messageHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let subuser = onBehalfOf {
            request.addValue(subuser, forHTTPHeaderField: "On-behalf-of")
        }
        
        request.HTTPMethod = resource.method.description
        
        if let params = resource.parameters {
            if resource.method.hasBody {
                var body: NSData?
                switch resource.contentType {
                case .FormUrlEncoded:
                    body = ParameterEncoding.FormUrlEncoded(params).data
                case .JSON:
                    body = ParameterEncoding.JSON(params).data
                default:
                    body = nil
                }
                request.HTTPBody = body
            } else if let query = ParameterEncoding.FormUrlEncoded(params).stringValue,
                newURL = NSURL(string: location.absoluteString + "?" + query)
            {
                request.URL = newURL
            }
        }
        
        guard let header = session.authentication?.authorizationHeader else {
            throw Error.Request.AuthorizationHeaderError
        }
        
        request.addValue(header, forHTTPHeaderField: "Authorization")
        request.addValue("sendgrid/\(Constants.Version);swift", forHTTPHeaderField: "User-Agent")
        
        return request
    }
}