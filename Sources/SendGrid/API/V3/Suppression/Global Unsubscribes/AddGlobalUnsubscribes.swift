import Foundation

/// The `AddGlobalUnsubscribes` class represents the API call to add email
/// addresses to the global unsubscribe list.
///
/// You can specify email addresses (as strings), or you can use `Address`
/// instances.
///
/// ```swift
/// do {
///     let request = AddGlobalUnsubscribes(emails: "foo@example.none", "bar@example.none")
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(let response, _):
///             print(response.statusCode)
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class AddGlobalUnsubscribes: Request {
    /// :nodoc:
    public typealias ResponseType = AddGlobalUnsubscribes.Parameters
    
    /// :nodoc:
    public let path: String = "/v3/asm/suppressions/global"
    
    /// :nodoc:
    public let method: HTTPMethod = .POST
    
    /// :nodoc:
    public private(set) var parameters: AddGlobalUnsubscribes.Parameters
    
    // MARK: - Initialization
    
    /// Initializes the request with a list of email addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of email addresses to add to the global
    ///                     unsubscribe list.
    public init(emails: [String]) {
        self.parameters = AddGlobalUnsubscribes.Parameters(emails: emails)
    }
    
    /// Initializes the request with a list of email addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of email addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(emails: String...) {
        self.init(emails: emails)
    }
    
    /// Initializes the request with a list of addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(addresses: [Address]) {
        let emails = addresses.map { $0.email }
        self.init(emails: emails)
    }
    
    /// Initializes the request with a list of addresses to add to the
    /// global unsubscribe list.
    ///
    /// - Parameter emails: An array of addresses to add to the global
    ///                     unsubscribe list.
    public convenience init(addresses: Address...) {
        self.init(addresses: addresses)
    }
}

public extension AddGlobalUnsubscribes /* Parameters Struct */ {
    /// The `AddGlobalUnsubscribes.Parameters` struct houses the parameters used
    /// to add email addresses to the global unsubscribe list.
    struct Parameters: ResponseRepresentable, Encodable {
        /// The email addresses to add to the global unsubscribe list.
        public let emails: [String]
        
        /// Initializes the struct with a list of email addresses.
        ///
        /// - Parameter emails: An array of email addresses.
        public init(emails: [String]) {
            self.emails = emails
        }
        
        /// Initializes the request with a list of email addresses.
        ///
        /// - Parameter emails: An array of email addresses.
        public init(emails: String...) {
            self.init(emails: emails)
        }
        
        /// :nodoc:
        public enum CodingKeys: String, CodingKey {
            case emails = "recipient_emails"
        }
    }
}
