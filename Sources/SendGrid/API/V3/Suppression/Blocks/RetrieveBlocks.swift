import Foundation

/// The `RetrieveBlocks` class represents the API call to [retrieve the block
/// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#List-all-blocks-GET).
/// You can use it to retrieve the entire list, or specific entries in the
/// list.
///
/// ## Get All Blocks
///
/// To retrieve the list of all blocks, use the `RetrieveBlocks` class with the
/// `init(start:end:page:)` initializer. The library will automatically map
/// the response to the `Block` struct model, accessible via the `model`
/// property on the response instance you get back.
///
/// ```swift
/// do {
///     // If you don't specify any parameters, then the first page of your
///     // entire block list will be fetched:
///     let request = RetrieveBlocks()
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(let response, let model):
///             // The `model` property will be an array of `Block` structs.
///             model.forEach { print($0.email) }
///
///             // The response object has a `Pagination` instance on it as well.
///             // You can use this to get the next page, if you wish.
///             if let nextPage = response.pages?.next {
///                 let nextRequest = RetrieveBlocks(page: nextPage)
///             }
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
///     // Blocks starting from yesterday
///     let now = Date()
///     let start = now.addingTimeInterval(-86400) // 24 hours
///
///     let request = RetrieveBlocks(start: start, end: now, page: page)
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` variable will be an array of `Block` structs.
///             model.forEach { print($0.email) }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// ## Get Specific Block
///
/// If you're looking for a specific email address in the block list, you
/// can use the `init(email:)` initializer on `RetrieveBlocks`:
///
/// ```swift
/// do {
///     let request = RetrieveBlocks(email: "foo@example.none")
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` property will be an array of `Block` structs.
///             model.forEach { item in
///                 print("\(item.email) was blocked with reason \"\(item.reason)\"")
///             }
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class RetrieveBlocks: SuppressionListReader, Request {
    /// :nodoc:
    public typealias ResponseType = Block
    
    /// :nodoc:
    internal override init(path: String?, email: String?, start: Date?, end: Date?, page: Page?) {
        super.init(
            path: "/v3/suppression/blocks",
            email: email,
            start: start,
            end: end,
            page: page
        )
    }
}
