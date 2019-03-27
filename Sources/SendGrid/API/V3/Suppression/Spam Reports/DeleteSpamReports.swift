//
//  DeleteSpamReports.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `DeleteSpamReports` class represents the API call to [delete from
/// the spam report list](https://sendgrid.com/docs/API_Reference/Web_API_v3/spam_reports.html#Delete-a-specific-spam-report-DELETE).
/// You can use it to delete the entire list, or specific entries from the
/// list.
///
/// ## Delete All Spam Reports
///
/// To delete all spam reports, use the request returned from
/// `DeleteSpamReports.all`.  This request will delete all spam reports on
/// your spam report list.
///
/// ```swift
/// do {
///     let request = DeleteSpamReports.all
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Delete Specific Spam Reports
///
/// To delete specific entries from your spam report list, use the
/// `DeleteSpamReports` class. You can either specify email addresses (as
/// strings), or you can use `SpamReport` instances (useful for if you just
/// retrieved some from the `RetrieveSpamReports` class).
///
/// ```swift
/// do {
///     let request = DeleteSpamReports(emails: "foo@example.none", "bar@example.none")
///     try Session.shared.send(request: request) { (response) in
///         print(response?.httpUrlResponse?.statusCode)
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class DeleteSpamReports: SuppressionListDeleter<SpamReport> {
    // MARK: - Properties
    
    /// Returns a request that will delete *all* the entries on your spam
    /// report list.
    public static var all: DeleteSpamReports {
        return DeleteSpamReports(deleteAll: true, emails: nil)
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
        super.init(path: "/v3/suppression/spam_reports", deleteAll: deleteAll, emails: emails)
    }
}
