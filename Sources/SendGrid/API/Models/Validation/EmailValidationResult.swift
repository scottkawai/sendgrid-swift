import Foundation

/// The `EmailValidationResult` represents the results returned from the email
/// validation API.
public struct EmailValidationResult: ResponseRepresentable {
    // MARK: - Properties

    /// The email address the validation results are for.
    public let email: String

    /// The overall verdict of the email.
    public let verdict: EmailValidationResult.Verdict

    /// The confidence score in the results.
    public let score: Float

    /// The local part, or portion before the `@` symbol, of the email address.
    public let local: String?

    /// The domain part, or portion after the `@` symbol, of the email address.
    public let host: String?

    /// In the event of a typo, this property will suggest a domain that might
    /// have been intended.
    public let suggestion: String?

    /// The results of the individual checks performed on the email address.
    public let checks: EmailValidationResult.Checks

    /// The source that was sent with the email.
    public let source: ValidateEmail.Source?

    /// The IP address of the requester.
    public let ipAddress: String?

    // MARK: - Initialization

    /// Initializes the struct with validation results.
    /// - Parameter email:      The email address the validation results are
    ///                         for.
    /// - Parameter verdict:    The overall verdict of the email.
    /// - Parameter score:      The confidence score in the results.
    /// - Parameter local:      The local part, or portion before the `@`
    ///                         symbol, of the email address.
    /// - Parameter host:       The domain part, or portion after the `@`
    ///                         symbol, of the email address.
    /// - Parameter suggestion: In the event of a typo, this property will
    ///                         suggest a domain that might have been intended.
    /// - Parameter checks:     The results of the individual checks performed
    ///                         on the email address.
    /// - Parameter ipAddress:  The IP address of the requester.
    public init(email: String,
                verdict: EmailValidationResult.Verdict,
                score: Float,
                local: String? = nil,
                host: String? = nil,
                suggestion: String? = nil,
                checks: EmailValidationResult.Checks,
                source: ValidateEmail.Source? = nil,
                ipAddress: String? = nil) {
        self.email = email
        self.verdict = verdict
        self.score = score
        self.local = local
        self.host = host
        self.suggestion = suggestion
        self.checks = checks
        self.source = source
        self.ipAddress = ipAddress
    }

    /// :nodoc:
    public init(from decoder: Decoder) throws {
        let wrapper = try decoder.container(keyedBy: EmailValidationResult.WrapperCodingKeys.self)
        let container = try wrapper.nestedContainer(keyedBy: EmailValidationResult.CodingKeys.self,
                                                    forKey: .result)
        try self.init(email: container.decode(String.self, forKey: .email),
                      verdict: container.decode(EmailValidationResult.Verdict.self, forKey: .verdict),
                      score: container.decode(Float.self, forKey: .score),
                      local: container.decodeIfPresent(String.self, forKey: .local),
                      host: container.decodeIfPresent(String.self, forKey: .host),
                      suggestion: container.decodeIfPresent(String.self, forKey: .suggestion),
                      checks: container.decode(EmailValidationResult.Checks.self, forKey: .checks),
                      source: container.decodeIfPresent(ValidateEmail.Source.self, forKey: .source),
                      ipAddress: container.decodeIfPresent(String.self, forKey: .ipAddress))
    }

    /// :nodoc:
    private enum CodingKeys: String, CodingKey {
        case email
        case verdict
        case score
        case local
        case host
        case suggestion
        case checks
        case source
        case ipAddress = "ip_address"
    }

    /// :nodoc:
    private enum WrapperCodingKeys: String, CodingKey {
        case result
    }
}

public extension EmailValidationResult /* Verdict */ {
    /// This enum represents all the possible verdicts returned from the email
    /// validation API.
    enum Verdict: String, CustomStringConvertible, Codable {
        // MARK: - Cases

        /// A valid classification.
        case valid = "Valid"

        /// A risky classification.
        case risky = "Risky"

        /// An invalid classification.
        case invalid = "Invalid"

        // MARK: - Properties

        /// :nodoc:
        public var description: String { self.rawValue }
    }
}

public extension EmailValidationResult /* Checks */ {
    /// The `EmailValidationResult.Checks` struct organizes all the individual
    /// checks performed on an email address.
    struct Checks: Decodable {
        // MARK: - Properties

        /// The checks performed on the domain.
        public let domain: DomainChecks

        /// The checks performed on the local part of the email address.
        public let localPart: LocalPartChecks

        /// Additional checks performed on the email address.
        public let additional: AdditionalChecks

        // MARK: - Initialization

        /// Initializes the struct with check results.
        /// - Parameter domain:     The checks performed on the domain.
        /// - Parameter localPart:  The checks performed on the local part of
        ///                         the email address.
        /// - Parameter additional: Additional checks performed on the email
        ///                         address.
        public init(domain: EmailValidationResult.DomainChecks, localPart: EmailValidationResult.LocalPartChecks, additional: EmailValidationResult.AdditionalChecks) {
            self.domain = domain
            self.localPart = localPart
            self.additional = additional
        }

        /// :nodoc:
        private enum CodingKeys: String, CodingKey {
            case domain
            case localPart = "local_part"
            case additional
        }
    }

    /// The `EmailValidationResult.DomainChecks` struct contains the results for
    /// all the checks performed on the email address' domain.
    struct DomainChecks: Decodable {
        // MARK: - Properties

        /// If true, then the address is a properly formatted email address
        /// (e.g. it has an @ sign and a top level domain). If false, then it's
        /// a malformed address.
        public let hasValidAddressSyntax: Bool

        /// If true, the domain on the address has all the necessary DNS records
        /// to deliver a message somewhere. If false, the domain is missing the
        /// required DNS records and will result in a bounce if sent to.
        public let hasMxOrARecord: Bool

        /// If true, the domain part of the email address appears to be from a
        /// disposable email address service, in which the addresses are only
        /// good for a short period of time.
        public let isSuspectedDisposableAddress: Bool

        // MARK: - Initialization

        /// Initializes the struct with check results.
        ///
        /// - Parameters:
        ///   - hasValidAddressSyntax:          Whether the email address has
        ///                                     the correct format.
        ///   - hasMxOrARecord:                 Whether the email address'
        ///                                     domain has the required DNS
        ///                                     records.
        ///   - isSuspectedDisposableAddress:   Whether the email address is
        ///                                     using a suspected disposable
        ///                                     email service.
        public init(hasValidAddressSyntax: Bool, hasMxOrARecord: Bool, isSuspectedDisposableAddress: Bool) {
            self.hasValidAddressSyntax = hasValidAddressSyntax
            self.hasMxOrARecord = hasMxOrARecord
            self.isSuspectedDisposableAddress = isSuspectedDisposableAddress
        }

        /// :nodoc:
        private enum CodingKeys: String, CodingKey {
            case hasValidAddressSyntax = "has_valid_address_syntax"
            case hasMxOrARecord = "has_mx_or_a_record"
            case isSuspectedDisposableAddress = "is_suspected_disposable_address"
        }
    }

    /// The `EmailValidationResult.LocalPartChecks` struct contains the results
    /// for all the checks performed on the email address' local part (the
    /// portion before the `@` sign).
    struct LocalPartChecks: Decodable {
        // MARK: - Properties

        /// If true, the local part of the email address (before the @ sign)
        /// appears to be a group email address such as “hr” or “admin”.
        public let isSuspectedRoleAddress: Bool

        // MARK: - Initialization

        /// Initializes the struct with check results.
        /// - Parameter isSuspectedRoleAddress: Indicates if the address appears
        ///                                     to be a group address.
        public init(isSuspectedRoleAddress: Bool) {
            self.isSuspectedRoleAddress = isSuspectedRoleAddress
        }

        /// :nodoc:
        private enum CodingKeys: String, CodingKey {
            case isSuspectedRoleAddress = "is_suspected_role_address"
        }
    }

    /// The `EmailValidationResult.AdditionalChecks` struct contains the results
    /// of additional checks performed against the email address.
    struct AdditionalChecks: Decodable {
        // MARK: - Properties

        /// If true, the email address has previously been sent to and has
        /// resulted in a bounce.
        public let hasKnownBounces: Bool

        /// If true, SendGrid's machine learning model suspects that the email address
        /// might bounce.
        public let hasSuspectedBounces: Bool

        // MARK: - Initialization

        /// Initializes the struct with the check results.
        /// - Parameter hasKnownBounces:        Indicates if the address has
        ///                                     bounced previously.
        /// - Parameter hasSuspectedBounces:    Indicates if the address is
        ///                                     predicted to bounce.
        internal init(hasKnownBounces: Bool, hasSuspectedBounces: Bool) {
            self.hasKnownBounces = hasKnownBounces
            self.hasSuspectedBounces = hasSuspectedBounces
        }

        /// :nodoc:
        private enum CodingKeys: String, CodingKey {
            case hasKnownBounces = "has_known_bounces"
            case hasSuspectedBounces = "has_suspected_bounces"
        }
    }
}
