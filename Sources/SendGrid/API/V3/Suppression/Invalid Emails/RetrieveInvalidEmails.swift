import Foundation

/// The `RetrieveInvalidEmails` class represents the API call to [retrieve the
/// invalid email list](https://sendgrid.com/docs/API_Reference/Web_API_v3/invalid_emails.html#List-all-invalid-emails-GET).
/// You can use it to retrieve the entire list, or specific entries from the
/// list.
///
/// ## Get All Invalid Emails
///
/// To retrieve the list of all invalid emails, use the `RetrieveInvalidEmails`
/// class with the `init(start:end:page:)` initializer. The library will
/// automatically map the response to the `InvalidEmail` struct model,
/// accessible via the `model` property on the response instance you get
/// back.
///
/// ```swift
/// do {
///     // If you don't specify any parameters, then the first page of your
///     // entire invalid email list will be fetched:
///     let request = RetrieveInvalidEmails()
///     try Session.shared.send(request: request) { (result) in
///         switch result {
///         case .success(let response):
///             // The `model` property will be an array of `InvalidEmail`
///             // structs.
///             response.model?.forEach { print($0.email) }
///
///             // The response object has a `Pagination` instance on it as
///             // well. You can use this to get the next page, if you wish.
///             //
///             // if let nextPage = response.pages?.next {
///             //    let nextRequest = RetrieveInvalidEmails(page: nextPage)
///             // }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// You can also specify any or all of the init parameters to filter your search
/// down:
///
/// ```swift
/// do {
///     // Retrieve page 2
///     let page = Page(limit: 500, offset: 500)
///     // Invalid emails starting from yesterday
///     let now = Date()
///     let start = now.addingTimeInterval(-86400) // 24 hours
///
///     let request = RetrieveInvalidEmails(start: start, end: now, page: page)
///     try Session.shared.send(request: request) { (result) in
///         switch result {
///         case .success(let response):
///             response.model?.forEach { print($0.email) }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Get Specific Invalid Email
///
/// If you're looking for a specific email address in the invalid email list,
/// you can use the `init(email:)` initializer on `RetrieveInvalidEmails`:
///
/// ```swift
/// do {
///     let request = RetrieveInvalidEmails(email: "foo@example")
///     try Session.shared.send(request: request) { (result) in
///         switch result {
///         case .success(let response):
///             response.model?.forEach { print($0.email) }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveInvalidEmails: SuppressionListReader<InvalidEmail> {
    /// :nodoc:
    internal override init(path: String?, email: String?, start: Date?, end: Date?, page: Page?) {
        super.init(
            path: "/v3/suppression/invalid_emails",
            email: email,
            start: start,
            end: end,
            page: page
        )
    }
}
