import Foundation

/// The `ValidateEmail` property allows you to validate an email address by
/// calling the [email validation endpoint](https://sendgrid.api-docs.io/v3.0/email-address-validation/validate-an-email).
///
/// **Note!** This API endpoint is only available for certain SendGrid
/// packages. See [SendGrid's website](https://sendgrid.com/solutions/email-validation-api/)
/// for more information.
///
/// When using this class, you need to specify an email address to validate:
///
/// ```swift
/// do {
///     let request = ValidateEmail(email: "john.doe@example.none")
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` variable will be an instance of
///             // `EmailValidationResult`.
///             print(model.verdict, model.score)
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// You can also specify a "source" along with the email. This allows you to
/// categorize the validations you're performing for later analysis in the
/// SendGrid UI. One common practice is to use the source to specify where the
/// current validation is being performed, such as a sign up form or support
/// page.
///
/// Sources are specified using the `ValidateEmail.Source` struct. This allows
/// you to create an extension with your sources so that you can easily
/// reference them throughout your code.
///
/// ```swift
/// public extension ValidateEmail.Source {
///     static let signUpForm = ValidateEmail.Source("Sign Up Form")
///     static let supportForm = ValidateEmail.Source("Support Form")
/// }
///
/// do {
///     let request = ValidateEmail(email: "john.doe@example.none", source: .signUpForm)
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` variable will be an instance of
///             // `EmailValidationResult`.
///             print(model.verdict, model.score)
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
///
/// You can also just specify the source as a `String`:
///
/// ```swift
/// do {
///     let request = ValidateEmail(email: "john.doe@example.none", source: "Sign Up Form")
///     try Session.shared.send(request: request) { result in
///         switch result {
///         case .success(_, let model):
///             // The `model` variable will be an instance of
///             // `EmailValidationResult`.
///             print(model.verdict, model.score)
///         case .failure(let err):
///             print(err)
///         }
///     }
/// } catch {
///     print(error)
/// }
/// ```
public class ValidateEmail: Request {
    // MARK: - Properties
    
    /// :nodoc:
    public typealias ResponseType = EmailValidationResult
    
    /// :nodoc:
    public let path: String = "/v3/validations/email"
    
    /// :nodoc:
    public let method: HTTPMethod = .POST
    
    /// :nodoc:
    public var parameters: ValidateEmail.Parameters
    
    // MARK: - Initialization
    
    /// Initializes the request with an email address to validate and an optional source.
    /// - Parameter email:  The email address to validate.
    /// - Parameter source: The source to tag the results with.
    public init(email: String, source: ValidateEmail.Source? = nil) {
        self.parameters = ValidateEmail.Parameters(email: email, source: source)
    }
    
    /// Initializes the request with an address to validate and an optional source.
    /// - Parameter address:    The address to validate.
    /// - Parameter source:     The source to tag the results with.
    public convenience init(address: Address, source: ValidateEmail.Source? = nil) {
        self.init(email: address.email, source: source)
    }
}

public extension ValidateEmail /* Source */ {
    /// The `ValidateEmail.Source` struct represents a category to use when
    /// validating an email address. These categories are then viewable and
    /// searchable in the SendGrid UI.
    ///
    /// Common practice is to create an extension with static values to
    /// represent the various sources you'll be using:
    ///
    /// ```swift
    /// public extension ValidateEmail.Source {
    ///     static let signUpForm = ValidateEmail.Source("Sign Up Form")
    ///     static let supportForm = ValidateEmail.Source("Support Form")
    /// }
    /// ```
    ///
    /// You can also use a normal `String` wherever a `ValidateEmail.Source`
    /// type is requested.
    struct Source: CustomStringConvertible, ExpressibleByStringLiteral, Encodable {
        // MARK: - Properties
        
        /// The string value of the source.
        public var description: String
        
        /// :nodoc:
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(self.description)
        }
        
        // MARK: - Initialization
        
        /// Initializes the source with a `String` value.
        /// - Parameter description: The `String` value of the source.
        public init(_ description: String) {
            self.description = description
        }
        
        /// :nodoc:
        public init(stringLiteral value: String) {
            self.init(value)
        }
    }
}

public extension ValidateEmail /* Parameters */ {
    /// The `ValidateEmail.Parameters` struct represents the parameters sent in
    /// the API request.
    struct Parameters: Encodable {
        // MARK: - Properties
        
        /// The email address to validate.
        public var email: String
        
        /// The source to tag the results with in the UI.
        public var source: ValidateEmail.Source?
        
        // MARK: - Initialization
        
        /// Initializes the struct with an email and optional source name.
        /// - Parameter email:  The email address to validate.
        /// - Parameter source: The source to tag the results with.
        public init(email: String, source: ValidateEmail.Source? = nil) {
            self.email = email
            self.source = source
        }
    }
}
