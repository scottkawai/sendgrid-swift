import Foundation

/// The `RetrieveGlobalUnsubscribes` class represents the API call to [retrieve
/// the global unsubscribe list](https://sendgrid.com/docs/API_Reference/Web_API_v3/Suppression_Management/global_suppressions.html#List-all-globally-unsubscribed-email-addresses-GET).
/// You can use it to retrieve the entire list, or specific entries on the
/// list.
///
/// ## Get All Global Unsubscribes
///
/// To retrieve the list of all global unsubscribes, use the
/// `RetrieveGlobalUnsubscribes` class with the `init(start:end:page:)`
/// initializer. The library will automatically map the response to the
/// `GlobalUnsubscribe` struct model, accessible via the `model` property on
/// the response instance you get back.
///
/// ```swift
/// do {
///     // If you don't specify any parameters, then the first page of your
///     // entire global unsubscribe list will be fetched:
///     let request = RetrieveGlobalUnsubscribes()
///     try Session.shared.send(request: result) { (response) in
///         switch result {
///         case .success(let response):
///             // The `model` property will be an array of `GlobalUnsubscribe` structs.
///             response.model?.forEach { print($0.email) }
///
///             // The response object has a `Pagination` instance on it as well.
///             // You can use this to get the next page, if you wish.
///             //
///             // if let nextPage = response.pages?.next {
///             //    let nextRequest = RetrieveGlobalUnsubscribes(page: nextPage)
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
/// You can also specify any or all of the init parameters to filter your
/// search down:
///
/// ```swift
/// do {
///     // Retrieve page 2
///     let page = Page(limit: 500, offset: 500)
///     // Global unsubscribes starting from yesterday
///     let now = Date()
///     let start = now.addingTimeInterval(-86400) // 24 hours
///
///     let request = RetrieveGlobalUnsubscribes(start: start, end: now, page: page)
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
/// ## Get Specific Global Unsubscribe
///
/// If you're looking for a specific email address in the global unsubscribe
/// list, you can use the `init(email:)` initializer on
/// `RetrieveGlobalUnsubscribes`:
///
/// ```swift
/// do {
///     let request = RetrieveGlobalUnsubscribes(email: "foo@example")
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
public class RetrieveGlobalUnsubscribes: SuppressionListReader<GlobalUnsubscribe> {
    /// :nodoc:
    internal override init(path: String?, email: String?, start: Date?, end: Date?, page: Page?) {
        super.init(
            path: "/v3/suppression/unsubscribes",
            email: email,
            start: start,
            end: end,
            page: page
        )
    }
}
