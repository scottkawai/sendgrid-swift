//
//  DeleteGlobalUnsubscribe.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `DeleteGlobalUnsubscribe` class represents the API call to [delete
/// from the invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/Suppression_Management/global_suppressions.html#Remove-an-email-address-from-the-Global-Unsubscribes-collection-DELETE).
///
/// You can specify an email address (as a
/// string), or you can use a `GlobalUnsubscribe` instance (useful for if
/// you just retrieved some from the `RetrieveGlobalUnsubscribes` class).
///
/// ```swift
/// do {
///     let request = DeleteGlobalUnsubscribe(email: "foo@example.none")
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class DeleteGlobalUnsubscribe: Request<EmptyCodable, EmptyCodable> {
    // MARK: - Initializer
    
    /// Initializes the request with an email address to delete from the
    /// global unsubscribe list.
    ///
    /// - Parameters:
    ///   - email:  An email address to delete from the global unsubscribe
    ///             list.
    public init(email: String) {
        super.init(method: .DELETE, path: "/v3/asm/suppressions/global/\(email)", parameters: nil)
    }
    
    /// Initializes the request with a global unsubscribe event that should
    /// be removed from the global unsubscribe list.
    ///
    /// - Parameter event:  A global unsubscribe event containing the email
    ///                     addresses to remove from the global unsubscribe \
    ///                     list.
    public convenience init(event: GlobalUnsubscribe) {
        self.init(email: event.email)
    }
}
