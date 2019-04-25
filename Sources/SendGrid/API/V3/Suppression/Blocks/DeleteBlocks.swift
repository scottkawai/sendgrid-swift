import Foundation

/// The `DeleteBlocks` class represents the API call to [delete from the
/// block list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#Delete-blocks-DELETE).
/// You can use it to delete the entire list, or specific entries in the
/// list.
///
/// ## Delete All Blocks
///
/// To delete all blocks, use the request returned from `DeleteBlocks.all`.
/// This request will delete all blocks on your block list.
///
/// ```swift
/// do {
///     let request = DeleteBlocks.all
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
/// ## Delete Specific Blocks
///
/// To delete specific entries from your block list, use the `DeleteBlocks`
/// class. You can either specify email addresses (as strings), or you can
/// use `Block` instances (useful for if you just retrieved some from the
/// `RetrieveBlocks` class).
///
/// ```swift
/// do {
///     let request = DeleteBlocks(emails: "foo@example.none", "bar@example.none")
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
public class DeleteBlocks: SuppressionListDeleter<Block> {
    // MARK: - Properties
    
    /// Returns a request that will delete *all* the entries on your block
    /// list.
    public static var all: DeleteBlocks {
        return DeleteBlocks(deleteAll: true, emails: nil)
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
        super.init(path: "/v3/suppression/blocks", deleteAll: deleteAll, emails: emails)
    }
}
