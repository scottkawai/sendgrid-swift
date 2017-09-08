//
//  Authentication.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//

import Foundation

/// The `Authentication` struct is used to authenticate all the requests made by
/// `Session`.
public struct Authentication: CustomStringConvertible {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The prefix used in the authorization header.
    public let prefix: String
    
    /// The value of the authorization header.
    public let value: String
    
    /// A description for the type of the authorization.
    public let description: String
    
    /// Returns that `Authorization` header value for the authentication type.
    /// This can be used on any web API V3 call.
    public var authorizationHeader: String {
        return "\(self.prefix) \(self.value)"
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct.
    ///
    /// - parameter prefix:        The prefix used in the authorization header.
    /// - parameter value:         The value of the authorization header.
    /// - parameter description:   A description of the authentication type.
    public init(prefix: String, value: String, description: String) {
        self.prefix = prefix
        self.value = value
        self.description = description
    }
    
    
    // MARK: - Deprecations
    //=========================================================================
    
    /// Initializes with a dictionary and returns the most appropriate
    /// authentication type.
    ///
    /// - parameter info:    A dictionary containing a `api_key`, or `username`
    /// and `password` key.
    @available(*, unavailable, message: "use the designated initializer or one of the static functions")
    public init?(info: [AnyHashable: Any]) { return nil }
    
    /// Retrieves the user value for the authentication type (applies only to
    /// `.credential`).
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    public var user: String? { return nil }
    
    /// Retrieves the key value for that authentication type. If the type is a
    /// `.Credentials`, this will be the password. Otherwise it will be the API
    /// key value.
    @available(*, unavailable, message: "use the `value` property to extrapolate the desired value")
    public var key: String { return self.value }
}

public extension Authentication {
    
    ///  Creates an `Authentication` instance representing an API key.
    ///
    /// - parameter key:   The SendGrid API key to use.
    ///
    /// - returns: An `Authentication` instance.
    static func apiKey(_ key: String) -> Authentication {
        return Authentication(prefix: "Bearer", value: key, description: "Authentication API Key")
    }
    
    /// Creates an `Authentication` instance representing a username and
    /// password.
    ///
    /// - parameter username:  The SendGrid username key to use.
    /// - parameter password:  The SendGrid password key to use.
    ///
    /// - returns: An `Authentication` instance.
    static func credential(username: String, password: String) throws -> Authentication {
        let str = "\(username):\(password)"
        guard let data = str.data(using: String.Encoding.utf8) else {
            throw Exception.Authentication.unableToEncodeCredentials
        }
        return Authentication(prefix: "Basic", value: data.base64EncodedString(), description: "Authentication credential")
    }
    
}
