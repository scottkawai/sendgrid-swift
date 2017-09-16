//
//  BCCSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation


/// This allows you to have a blind carbon copy automatically sent to the
/// specified email address for every email that is sent.
public struct BCCSetting {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggled on or off.
    public var enable: Bool { return self.email != nil }
    
    /// The email address that you would like to receive the BCC.
    public let email: Address?

    
    // MARK: - Initialization
    //=========================================================================

    /// Initializes the setting with an email to use as the BCC address. This
    /// setting can also be used to turn off the BCC app if it is normally on by
    /// default on your SendGrid account. To turn off the setting for this
    /// specific email, pass in `nil` as the address.
    ///
    /// - Parameters:
    ///   - email:  An `Address` instance to set as the BCC, or `nil` if you
    ///             want the setting to be turned off.
    public init(address: Address?) {
        self.email = address
    }
    
    /// Initializes the setting with an email to use as the BCC address.
    ///
    /// - Parameters:
    ///   - email:  A `String` representing the email address to set as the BCC.
    public init(email: String) {
        let address = Address(email: email)
        self.init(address: address)
    }
    
}

/// Encodable conformance
extension BCCSetting: Encodable {
    
    public enum CodingKeys: String, CodingKey {
        case enable, email
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.enable, forKey: .enable)
        try container.encodeIfPresent(self.email?.email, forKey: .email)
    }
    
}


/// Validatable conformance
extension BCCSetting: Validatable {
    
    /// Validates that the BCC email is a valid email address.
    public func validate() throws {
        try self.email?.validate()
    }

}
