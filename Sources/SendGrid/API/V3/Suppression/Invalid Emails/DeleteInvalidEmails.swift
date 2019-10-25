import Foundation

/// The `DeleteInvalidEmails.Delete` class represents the API call to [delete from
/// the invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#Delete-invalid-emails-DELETE).
/// You can use it to delete the entire list, or specific entries on the
/// list.
///
/// ## Delete All Invalid Emails
///
/// To delete all invalid emails, use the request returned from
/// `DeleteInvalidEmails.all`.  This request will delete all addresses on
/// your invalid email list.
///
/// ```swift
/// do {
///     let request = DeleteInvalidEmails.all
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
///
/// ## Delete Specific Invalid Emails
///
/// To delete specific entries from your invalid email list, use the
/// `DeleteInvalidEmails` class. You can either specify email addresses (as
/// strings), or you can use `InvalidEmail` instances (useful for if you
/// just retrieved some from the `RetrieveInvalidEmails` class).
///
/// ```swift
/// do {
///     let request = DeleteInvalidEmails(emails: "foo@example", "bar@example")
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
public class DeleteInvalidEmails: SuppressionListDeleter<InvalidEmail>, Request {
    // MARK: - Properties
    
    /// Returns a request that will delete *all* the entries on your spam
    /// report list.
    public static var all: DeleteInvalidEmails {
        DeleteInvalidEmails(deleteAll: true, emails: nil)
    }
    
    // MARK: - Initialization
    
    /// Private initializer to set all the required properties.
    ///
    /// - Parameters:
    ///   - path:       The path for the request's API endpoint.
    ///   - deleteAll:  A `Bool` indicating if all the events on the suppression
    ///                 list should be deleted.
    ///   - emails:     An array of emails to delete from the suppression list.
    internal override init(path: String? = nil, deleteAll: Bool?, emails: [String]?) {
        super.init(path: "/v3/suppression/invalid_emails", deleteAll: deleteAll, emails: emails)
    }
}
