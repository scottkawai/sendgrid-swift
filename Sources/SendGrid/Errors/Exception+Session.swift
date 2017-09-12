//
//  Exception+Session.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/12/17.
//

import Foundation

public extension Exception {
    
    /// The `Session` enum contains all the errors thrown when attempting to
    /// build an HTTP request.
    public enum Session: Error, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// Represents an error where no authentication method was provided.
        case authenticationMissing
        
        /// Represents an error where an unsupported authentication method was used.
        case authenticationTypeNotAllowed(AnyClass, Authentication)
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .authenticationMissing:
                return "Could not make an HTTP request as there was no `Authentication` configured on `Session`. Please set the `authentication` property before calling `send` on `Session`."
                
            case .authenticationTypeNotAllowed(let object, let authType):
                return "The `\(object)` class does not allow authentication with \(authType)s. Please try using another Authentication type."
            }
        }
    }
}
