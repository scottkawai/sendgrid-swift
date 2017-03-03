//
//  BCCSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 This allows you to have a blind carbon copy automatically sent to the specified email address for every email that is sent.
 
 */
open class BCCSetting: Setting, MailSetting, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The email address that you would like to receive the BCC.
    open let email: Address
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        hash["email"] = self.email.email
        return [
            "bcc": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the setting with an email to use as the BCC address. If the address is malformed, an error is thrown.
     
     - parameter enable:	A bool indicating if the setting should be on or off.
     - parameter email:     An email address to set as the BCC.
     
     */
    public init(enable: Bool, email: Address) {
        self.email = email
        super.init(enable: enable)
    }
    

    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the BCC email is a valid email address.
     
     */
    open func validate() throws {
        try self.email.validate()
    }
}
