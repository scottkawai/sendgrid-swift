//
//  DeleteBounces.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `DeleteBounces` class represents the API call to [delete from the
/// bounce list](https://sendgrid.com/docs/API_Reference/Web_API_v3/bounces.html#Delete-bounces-DELETE).
/// You can use it to delete the entire list, or specific entries from the
/// list.
///
/// ## Delete All Bounces
///
/// To delete all bounces, use the request returned from
/// `DeleteBounces.all`.  This request will delete all bounces on your
/// bounce list.
///
/// ```swift
/// do {
///     let request = DeleteBounces.all
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Delete Specific Bounces
///
/// To delete specific entries from your bounce list, use the
/// `DeleteBounces` class. You can either specify email addresses (as
/// strings), or you can use `Bounce` instances (useful for if you just retrieved
/// some from the `RetrieveBounces` class).
///
/// ```swift
/// do {
///     let request = DeleteBounces(emails: "foo@example.none", "bar@example.none")
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class DeleteBounces: SuppressionListDeleter<Bounce> {
    // MARK: - Properties
    
    /// Returns a request that will delete *all* the entries on your bounce
    /// list.
    public static var all: DeleteBounces {
        return DeleteBounces(deleteAll: true, emails: nil)
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
        super.init(path: "/v3/suppression/bounces", deleteAll: deleteAll, emails: emails)
    }
}
