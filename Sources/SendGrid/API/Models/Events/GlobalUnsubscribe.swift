import Foundation

/// The `GlobalUnsubscribe` struct represents an entry on the "Global
/// Unsubscribe" suppression list.
public struct GlobalUnsubscribe: EmailEventRepresentable, Codable {
    // MARK: - Properties
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    // MARK: - Initialization
    
    /// Initializes the event with all the required properties.
    ///
    /// - Parameters:
    ///   - email:      The email address on the event.
    ///   - created:    The date and time the event occurred on.
    public init(email: String, created: Date) {
        self.email = email
        self.created = created
    }
}
