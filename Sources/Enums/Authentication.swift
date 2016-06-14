//
//  Authentication.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/9/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Authentication` enum is used to represent the various ways you can authenticate with the SendGrid API.  Aside from representing the different methods, they also store the values of the desired authentication method.
 
 */
public enum Authentication: CustomStringConvertible {
    
    // MARK: - Cases
    //=========================================================================
    
    /// Used to authenticate with a username and password.
    case Credential(username: String, password: String)
    
    /// Used to authenticate with a SendGrid API Key.
    case ApiKey(String)
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes with a dictionary and returns the most appropriate authentication type.
     
     - parameter info:	A dictionary containing a `api_key`, or `username` and `password` key.
     
     */
    public init?(info: [NSObject : AnyObject]) {
        if let k = info["api_key"] as? String {
            self = Authentication.ApiKey(k)
        } else if let un = info["username"] as? String, pw = info["password"] as? String {
            self = Authentication.Credential(username: un, password: pw)
        } else {
            return nil
        }
    }
    
    
    // MARK: - Properties
    //=========================================================================
    
    /// Retrieves the user value for the authentication type (applies only to `.Credential`).
    public var user: String? {
        switch self {
        case .Credential(let un, _):
            return un
        default:
            return nil
        }
    }
    
    /// Retrieves the key value for that authentication type. If the type is a `.Credentials`, this will be the password. Otherwise it will be the API key value.
    public var key: String {
        switch self {
        case .Credential(_, let pw):
            return pw
        case .ApiKey(let k):
            return k
        }
    }
    
    /// Returns that `Authorization` header value for the authentication type.  This can be used on any web API V3 call.
    public var authorizationHeader: String? {
        switch self {
        case .Credential(let un, let pw):
            let str = "\(un):\(pw)"
            guard let data = str.dataUsingEncoding(NSUTF8StringEncoding) else {
                return nil
            }
            return "Basic " + data.base64EncodedStringWithOptions([])
        case .ApiKey(let k):
            return "Bearer \(k)"
        }
    }
    
    
    /// The ID of authentication type.
    public var description: String {
        switch self {
        case .Credential(_,_):
            return "credential"
        case .ApiKey(_):
            return "API Key"
        }
    }

}