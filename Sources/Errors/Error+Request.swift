//
//  Error+Request.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

public extension Error {
    
    /**
     
     The `Request` enum contains all the errors thrown when attempting to build an HTTP request.
     
     */
    public enum Request: ErrorType, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// Represents an attempt to use a class that doesn't conform to `Request`.
        case NonConformingRequest(AnyClass)
        
        /// Represents an error in constructing the URL for an API call.
        case UnableToConstructUrl
        
        /// Represents an error where the "Authorization" error couldn't be added to the API call.
        case AuthorizationHeaderError
        
        /// Thrown when attempting to use the "onBehalfOf" feature on an API call that doesn't support it.
        case ImpersonationNotSupported(AnyClass)
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .NonConformingRequest(let obj):
                return "Could not build an `NSURLRequest` from `\(obj)` as it doesn't conform to `Request`."
            case .UnableToConstructUrl:
                return "There was a problem attempting to build the URL for the API call. Double check the `endpoint` property of your Request and the `host` property of `Session` to ensure they can form a valid URL."
            case .AuthorizationHeaderError:
                return "There was an error trying to add an `Authorization` header to the API request.  Double check the credentials and ensure there's no special characters."
            case .ImpersonationNotSupported(let obj):
                return "The `\(obj)` class does not support subuser impersonation. Please try making your request again leaving the `onBehalfOf` parameter `nil`."
            }
        }
    }
}