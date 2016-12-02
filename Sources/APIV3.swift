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
open class APIV3 {
    
    // MARK: - Properties
    //=========================================================================
    /// Additional headers to add to the HTTP request.
    open var messageHeaders: [String:String] {
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
    open func request(for session: Session, onBehalfOf: String?) throws -> URLRequest {
        guard let header = session.authentication?.authorizationHeader else {
            throw SGError.Request.authorizationHeaderError
        }
        guard let resource = self as? Request else {
            throw SGError.Request.nonConformingRequest(type(of: self))
        }
        guard let location = URL(string: session.host)?.appendingPathComponent(resource.endpoint) else {
            throw SGError.Request.unableToConstructUrl
        }
        
        var request = URLRequest(url: location)
        
        for (key, value) in resource.messageHeaders {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let subuser = onBehalfOf {
            request.addValue(subuser, forHTTPHeaderField: "On-behalf-of")
        }
        
        request.httpMethod = resource.method.description
        
        if let params = resource.parameters {
            if resource.method.hasBody {
                var body: Data?
                switch resource.contentType {
                case .formUrlEncoded:
                    body = ParameterEncoding.formUrlEncodedData(from: params)
                case .json:
                    body = ParameterEncoding.jsonData(from: params)
                default:
                    body = nil
                }
                request.httpBody = body
            } else if let query = ParameterEncoding.formUrlEncodedString(from: params),
                let newURL = URL(string: location.absoluteString + "?" + query)
            {
                request.url = newURL
            }
        }
        
        request.addValue(header, forHTTPHeaderField: "Authorization")
        request.addValue("sendgrid/\(Constants.Version);swift", forHTTPHeaderField: "User-Agent")

        return request
    }
}
