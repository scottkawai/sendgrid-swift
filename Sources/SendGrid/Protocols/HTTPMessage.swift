//
//  HTTPMessage.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `HTTPMessage` protocol defines the properties and methods required to be used as an HTTP request or response.
 
 */
public protocol HTTPMessage {
    
    // MARK: - Properties
    //=========================================================================

    /// The endpoint for this API call.
    var endpoint: String { get }
    
    /// The HTTP method that should be used for the API call.
    var method: HTTPMethod { get }
    
    /// The Content-Type of the request body.
    var contentType: ContentType { get }
    
    /// The headers on the message.
    var messageHeaders: [String:String] { get }
    
}