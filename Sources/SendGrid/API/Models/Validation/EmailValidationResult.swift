import Foundation

public struct EmailValidationResult: ResponseRepresentable {
    public let email: String
    public let verdict: EmailValidationResult.Verdict
    public let score: Float
    public let local: String?
    public let host: String?
    public let suggestion: String?
    public let checks: EmailValidationResult.Checks
    public let ipAddress: String?
    
    public init(from decoder: Decoder) throws {
        let wrapper = try decoder.container(keyedBy: EmailValidationResult.WrapperCodingKeys.self)
        let container = try wrapper.nestedContainer(keyedBy: EmailValidationResult.CodingKeys.self,
                                                    forKey: .result)
        self.email = try container.decode(String.self, forKey: .email)
        self.verdict = try container.decode(EmailValidationResult.Verdict.self, forKey: .verdict)
        self.score = try container.decode(Float.self, forKey: .score)
        self.checks = try container.decode(EmailValidationResult.Checks.self, forKey: .checks)
        self.local = try container.decodeIfPresent(String.self, forKey: .local)
        self.host = try container.decodeIfPresent(String.self, forKey: .host)
        self.suggestion = try container.decodeIfPresent(String.self, forKey: .suggestion)
        self.ipAddress = try container.decodeIfPresent(String.self, forKey: .ipAddress)
    }
    
    private enum CodingKeys: String, CodingKey {
        case email
        case verdict
        case score
        case local
        case host
        case suggestion
        case checks
        case ipAddress = "ip_address"
    }
    
    private enum WrapperCodingKeys: String, CodingKey {
        case result
    }
}

public extension EmailValidationResult /* Verdict */ {
    enum Verdict: String, CustomStringConvertible, Codable {
        case valid = "Valid"
        case risky = "Risky"
        case invalid = "Invalid"
        
        public var description: String { self.rawValue }
    }
}

public extension EmailValidationResult /* Checks */ {
    struct Checks: Decodable {
        public let domain: DomainChecks
        public let localPart: LocalPartChecks
        public let additional: AdditionalChecks
        
        private enum CodingKeys: String, CodingKey {
            case domain
            case localPart = "local_part"
            case additional
        }
    }
    
    struct DomainChecks: Decodable {
        public let hasValidAddressSyntax: Bool
        public let hasMxOrARecord: Bool
        public let isSuspectedDisposableAddress: Bool
        
        private enum CodingKeys: String, CodingKey {
            case hasValidAddressSyntax = "has_valid_address_syntax"
            case hasMxOrARecord = "has_mx_or_a_record"
            case isSuspectedDisposableAddress = "is_suspected_disposable_address"
        }
    }
    
    struct LocalPartChecks: Decodable {
        public let isSuspectedRoleAddress: Bool
        
        private enum CodingKeys: String, CodingKey {
            case isSuspectedRoleAddress = "is_suspected_role_address"
        }
    }
    
    struct AdditionalChecks: Decodable {
        public let hasKnownBounces: Bool
        public let hasSuspectedBounces: Bool
        
        private enum CodingKeys: String, CodingKey {
            case hasKnownBounces = "has_known_bounces"
            case hasSuspectedBounces = "has_suspected_bounces"
        }
    }
}
