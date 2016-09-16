//
//  Address.swift
//  SendGrid
//
//  Created by Scott Kawai on 7/26/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Address` class represents an email address and contains the email address along with an optional display name.
 
 */
open class Address: JSONConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// An optional name to display instead of the email address.
    open let name: String?
    
    /// An email address.
    open let email: String
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the Address, used to generate the JSON payload sent to the SendGrid API.
    open var dictionaryValue: [AnyHashable: Any] {
        var hash: [String:String] = [
            "email": self.email
        ]
        if let n = self.name {
            hash["name"] = n
        }
        return hash
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the address with an email address and an optional display name.
     
     - parameter emailAddress:	The email address.
     - parameter displayName:   An optional display name.
     
     */
    public init(emailAddress: String, displayName: String? = nil) {
        self.email = emailAddress
        self.name = displayName
    }
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the email address is an RFC compliant email address.
     
     */
    open func validate() throws {
        if !Validator.email(self.email).valid { throw SGError.Mail.malformedEmailAddress(self.email) }
    }
    
}
