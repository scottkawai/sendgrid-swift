//
//  GlobalUnsubscribe.Add.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

/// The `GlobalUnsubscribe.Add` class represents the API call to add email
/// addresses to the global unsubscribe list.
///
/// You can specify email addresses (as strings), or you can use `Address`
/// instances.
///
/// ```swift
/// do {
///     let request = GlobalUnsubscribe.Add(emails: "foo@example.none", "bar@example.none")
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class AddGlobalUnsubscribes: Request<EmptyCodable, AddGlobalUnsubscribes.Parameters> {
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the request with a list of email addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of email addresses to add to the global
    ///                     unsubscribe list.
    public init(emails: [String]) {
        let params = AddGlobalUnsubscribes.Parameters(emails: emails)
        super.init(method: .POST, path: "/v3/asm/suppressions/global", parameters: params)
    }
    
    /// Initializes the request with a list of email addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of email addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(emails: String...) {
        self.init(emails: emails)
    }
    
    /// Initializes the request with a list of addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(addresses: [Address]) {
        let emails = addresses.map { $0.email }
        self.init(emails: emails)
    }
    
    /// Initializes the request with a list of addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(addresses: Address...) {
        self.init(addresses: addresses)
    }
    
}

public extension AddGlobalUnsubscribes /* Parameters Struct */ {
    
    /// The `AddGlobalUnsubscribes.Parameters` struct houses the parameters used
    /// to add email addresses to the global unsubscribe list.
    public struct Parameters: Encodable {
        
        /// The email addresses to add to the global unsubscribe list.
        public let emails: [String]
        
        /// Initializes the struct with a list of email addresses.
        ///
        /// - Parameter emails: An array of email addresses.
        public init(emails: [String]) {
            self.emails = emails
        }
        
        /// Initializes the request with a list of email addresses.
        ///
        /// - Parameter emails: An array of email addresses.
        public init(emails: String...) {
            self.init(emails: emails)
        }
        
    }
    
}
