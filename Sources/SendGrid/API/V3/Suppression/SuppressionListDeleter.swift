import Foundation

/// The `SuppressionListDeleter` class is base class inherited by requests that
/// delete entries from a supression list. You should not use this class
/// directly.
public class SuppressionListDeleter<T: EmailEventRepresentable>: Request<SuppressionListDeleterParameters> {
    // MARK: - Initializer
    
    /// Private initializer to set all the required properties.
    ///
    /// - Parameters:
    ///   - path:       The path for the request's API endpoint.
    ///   - deleteAll:  A `Bool` indicating if all the events on the suppression
    ///                 list should be deleted.
    ///   - emails:     An array of emails to delete from the suppression list.
    internal init(path: String? = nil, deleteAll: Bool?, emails: [String]?) {
        let params = SuppressionListDeleterParameters(deleteAll: deleteAll, emails: emails)
        super.init(method: .DELETE, path: path ?? "/", parameters: params)
    }
    
    /// Initializes the request with an array of email addresses to delete
    /// from the suppression list.
    ///
    /// - Parameter emails: An array of emails to delete from the suppression
    ///                     list.
    public convenience init(emails: [String]) {
        self.init(deleteAll: nil, emails: emails)
    }
    
    /// Initializes the request with an array of email addresses to delete
    /// from the suppression list.
    ///
    /// - Parameter emails: An array of emails to delete from the suppression
    ///                     list.
    public convenience init(emails: String...) {
        self.init(emails: emails)
    }
    
    /// Initializes the request with an array of events that should
    /// be removed from the suppression list.
    ///
    /// - Parameter events: An array of events containing email addresses to
    ///                     remove from the suppression list.
    public convenience init(events: [T]) {
        let emails = events.map { $0.email }
        self.init(emails: emails)
    }
    
    /// Initializes the request with an array of events that should be removed
    /// from the suppression list.
    ///
    /// - Parameter events: An array of events containing email addresses to
    ///                     remove from the suppression list.
    public convenience init(events: T...) {
        self.init(events: events)
    }
}

/// The `SuppressionListDeleterParameters` struct houses all the parameters that
/// can be made for the suppression delete calls.
public struct SuppressionListDeleterParameters: Codable {
    /// A `Bool` indicating if all the events on the suppression list should be
    /// deleted.
    public let deleteAll: Bool?
    
    /// An array of emails to delete from the suppression list.
    public let emails: [String]?
    
    /// Initializes the struct.
    ///
    /// - Parameters:
    ///   - deleteAll:  A `Bool` indicating if all the events on the suppression
    ///                 list should be deleted.
    ///   - emails:     An array of emails to delete from the suppression list.
    public init(deleteAll: Bool?, emails: [String]?) {
        self.deleteAll = deleteAll
        self.emails = emails
    }
    
    /// :nodoc:
    public enum CodingKeys: String, CodingKey {
        case deleteAll = "delete_all"
        case emails
    }
}
