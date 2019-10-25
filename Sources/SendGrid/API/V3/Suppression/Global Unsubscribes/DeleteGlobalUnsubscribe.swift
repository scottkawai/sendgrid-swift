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
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(let response):
///             print(response.statusCode)
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class DeleteGlobalUnsubscribe: Request {
    /// :nodoc:
    public typealias ResponseType = Never
    
    /// :nodoc:
    public let method: HTTPMethod = .DELETE
    
    /// :nodoc:
    public let path: String
    
    /// :nodoc:
    public let parameters: Never? = nil
        
    // MARK: - Initializer
    
    /// Initializes the request with an email address to delete from the
    /// global unsubscribe list.
    ///
    /// - Parameters:
    ///   - email:  An email address to delete from the global unsubscribe
    ///             list.
    public init(email: String) {
        self.path = "/v3/asm/suppressions/global/\(email)"
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
