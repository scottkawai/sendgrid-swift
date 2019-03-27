import Foundation

/// The `Address` struct represents an email address and contains the email
/// address along with an optional display name.
public struct Address: Encodable {
    // MARK: - Properties
    
    /// An optional name to display instead of the email address.
    public let name: String?
    
    /// An email address.
    public let email: String
    
    // MARK: - Initialization
    
    /// Initializes the address with an email address and an optional display name.
    ///
    /// - Parameters:
    ///   - email:  The email address.
    ///   - name:   An optional display name.
    public init(email: String, name: String? = nil) {
        self.email = email
        self.name = name
    }
}

extension Address: Validatable {
    /// Validates that the email address is an RFC compliant email address.
    public func validate() throws {
        guard Validate.email(self.email) else {
            throw Exception.Mail.malformedEmailAddress(self.email)
        }
    }
}

extension Address: ExpressibleByStringLiteral /* Allow initialization from a raw `String` */ {
    /// This initializer allows you to create an `Address` instance from a
    /// `String`:
    ///
    /// ```
    /// let address: Address = "foo@bar.none"
    /// ```
    ///
    /// - Parameter value: The email address to use in the `Address`.
    public init(stringLiteral value: String) {
        self.init(email: value)
    }
}
