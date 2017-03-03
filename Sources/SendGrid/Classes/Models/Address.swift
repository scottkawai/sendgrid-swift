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
        var hash: [AnyHashable:Any] = [
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
     
     - parameter email: The email address.
     - parameter name:  An optional display name.
     
     */
    public init(email: String, name: String?) {
        self.email = email
        self.name = name
    }
    
    /**
     
     Initializes the address with a String representing the email address.
     
     - parameter email: The email address.
     
     */
    public convenience init(_ email: String) {
        self.init(email: email, name: nil)
    }
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the email address is an RFC compliant email address.
     
     */
    open func validate() throws {
        guard Validator.email(self.email).valid else { throw SGError.Mail.malformedEmailAddress(self.email) }
    }
    
}
