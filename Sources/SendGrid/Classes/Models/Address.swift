//
//  Address.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/13/17.
//

import Foundation

/// The `Address` class represents an email address and contains the email
/// address along with an optional display name.
open class Address: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// An optional name to display instead of the email address.
    public let name: String?
    
    /// An email address.
    public let email: String
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the address with an email address and an optional display name.
    ///
    /// - Parameters:
    ///   - email:  The email address.
    ///   - name:   An optional display name.
    public init(email: String, name: String?) {
        self.email = email
        self.name = name
    }
    
	
    /// Initializes the address with a String representing the email address.
    ///
    /// - Parameter email: The email address.
    public convenience init(_ email: String) {
        self.init(email: email, name: nil)
    }
    
}

/// Validatable conformance.
extension Address: Validatable {
    
    /// Validates that the email address is an RFC compliant email address.
    open func validate() throws {
        guard Validate.email(self.email) else {
            throw Exception.Mail.malformedEmailAddress(self.email)
        }
    }
    
}
