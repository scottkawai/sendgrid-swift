//
//  SGError+Request.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

public extension SGError {
    
    /**
     
     The `Request` enum contains all the errors thrown when attempting to build an HTTP request.
     
     */
    public enum Request: Error, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// Represents an attempt to use a class that doesn't conform to `Request`.
        case nonConformingRequest(AnyClass)
        
        /// Represents an error in constructing the URL for an API call.
        case unableToConstructUrl
        
        /// Represents an error where the "Authorization" error couldn't be added to the API call.
        case authorizationHeaderError
        
        /// Thrown when attempting to use the "onBehalfOf" feature on an API call that doesn't support it.
        case impersonationNotSupported(AnyClass)
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .nonConformingRequest(let object):
                return String(format: NSLocalizedString(
                    "Could not build an `NSURLRequest` from `%@` as it doesn't conform to `Request`.",
                    comment: "Non-conforming request"),  String(describing: object))
                
            case .unableToConstructUrl:
                return NSLocalizedString(
                    "There was a problem attempting to build the URL for the API call. Double check the `endpoint` property of your Request and the `host` property of `Session` to ensure they can form a valid URL.",
                    comment: "Unable to construct URL")
                
            case .authorizationHeaderError:
                return NSLocalizedString(
                    "There was an error trying to add an `Authorization` header to the API request.  Double check the credentials and ensure there's no special characters.",
                    comment: "Authorization header error")
                
            case .impersonationNotSupported(let object):
                return String(format: NSLocalizedString(
                    "The `%@` class does not support subuser impersonation. Please try making your request again leaving the `onBehalfOf` parameter `nil`.",
                    comment: "Impersonation not supported"), String(describing: object))
            }
        }
    }
}
