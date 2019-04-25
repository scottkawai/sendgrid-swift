import Foundation

/// The `Bounce` struct represents a bounce event.
public struct Bounce: EmailEventRepresentable, Codable {
    // MARK: - Properties
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    /// The response from the recipient server.
    public let reason: String
    
    /// The status code of the event.
    public let status: String
    
    // MARK: - Initialization
    
    /// Initializes the event with all the required properties.
    ///
    /// - Parameters:
    ///   - email:      The email address on the event.
    ///   - created:    The date and time the event occurred on.
    ///   - reason:     The response from the recipient server.
    ///   - status:     The status code of the event.
    public init(email: String, created: Date, reason: String, status: String) {
        self.email = email
        self.created = created
        self.reason = reason
        self.status = status
    }
}
