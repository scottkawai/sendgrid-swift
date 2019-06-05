import Foundation

/// The `Personalization` struct is used by the `Email` class to add
/// personalization settings to an email. The only required property is the `to`
/// property, and each email must have at least one personalization.
open class Personalization: Encodable, EmailHeaderRepresentable, Scheduling {
    // MARK: - Properties
    
    /// An array of recipients to send the email to.
    public var to: [Address]
    
    /// An array of recipients to add as a CC on the email.
    open var cc: [Address]?
    
    /// An array of recipients to add as a BCC on the email.
    open var bcc: [Address]?
    
    /// A personalized subject for the email.
    open var subject: String?
    
    /// An optional set of headers to add to the email in this personalization.
    /// Each key in the dictionary should represent the name of the header, and
    /// the values of the dictionary should be equal to the values of the
    /// headers.
    open var headers: [String: String]?
    
    /// An optional set of substitutions to replace in this personalization. The
    /// keys in the dictionary should represent the substitution tags that
    /// should be replaced, and the values should be the replacement values.
    open var substitutions: [String: String]?
    
    /// A set of custom arguments to add to the email. The keys of the
    /// dictionary should be the names of the custom arguments, while the values
    /// should represent the value of each custom argument.
    open var customArguments: [String: String]?
    
    /// An optional time to send the email at.
    open var sendAt: Date?
    
    // MARK: - Initialization
    
    /// Initializes the email with all the available properties.
    ///
    /// - Parameters:
    ///   - to:                 An array of addresses to send the email to.
    ///   - cc:                 An array of addresses to add as CC.
    ///   - bcc:                An array of addresses to add as BCC.
    ///   - subject:            A subject to use in the personalization.
    ///   - headers:            A set of additional headers to add for this
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the name of the
    ///                         headers and their values, respectively.
    ///   - substitutions:      A set of substitutions to make in this
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the substitution
    ///                         tags and their replacement values, respectively.
    ///   - customArguments:    A set of custom arguments to add to the
    ///                         personalization. The keys and values in the
    ///                         dictionary should represent the argument names
    ///                         and values, respectively.
    ///   - sendAt:             A time to send the email at.
    public init(to: [Address], cc: [Address]? = nil, bcc: [Address]? = nil, subject: String? = nil, headers: [String: String]? = nil, substitutions: [String: String]? = nil, customArguments: [String: String]? = nil, sendAt: Date? = nil) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.headers = headers
        self.substitutions = substitutions
        self.customArguments = customArguments
        self.sendAt = sendAt
    }
    
    /// Initializes the personalization with a set of email addresses.
    ///
    /// - Parameter recipients: A list of email addresses to use as the "to"
    ///                         addresses.
    public convenience init(recipients: String...) {
        let list: [Address] = recipients.map { Address(email: $0) }
        self.init(to: list)
    }
    
    // MARK: - Encodable Conformance
    
    /// :nodoc:
    open func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Personalization._CodingKeys.self)
        try container.encode(self.to, forKey: .to)
        try container.encodeIfPresent(self.cc, forKey: .cc)
        try container.encodeIfPresent(self.bcc, forKey: .bcc)
        try container.encodeIfPresent(self.subject, forKey: .subject)
        try container.encodeIfPresent(self.headers, forKey: .headers)
        try container.encodeIfPresent(self.substitutions, forKey: .substitutions)
        try container.encodeIfPresent(self.customArguments, forKey: .customArguments)
        try container.encodeIfPresent(self.sendAt, forKey: .sendAt)
    }
    
    /// :nodoc:
    private enum _CodingKeys: String, CodingKey {
        case to
        case cc
        case bcc
        case subject
        case headers
        case substitutions
        case customArguments = "custom_args"
        case sendAt = "send_at"
    }
}

extension Personalization: Validatable {
    /// Validates that the personalization has recipients and that they are
    /// proper email addresses as well as making sure the sendAt date is valid.
    open func validate() throws {
        guard self.to.count > 0 else { throw Exception.Mail.missingRecipients }
        try self.validateHeaders()
        try self.validateSendAt()
        try self.to.forEach { try $0.validate() }
        try self.cc?.forEach { try $0.validate() }
        try self.bcc?.forEach { try $0.validate() }
        
        if let s = self.subject {
            guard s.count > 0 else { throw Exception.Mail.missingSubject }
        }
        
        if let sub = self.substitutions {
            guard sub.count <= Constants.SubstitutionLimit else { throw Exception.Mail.tooManySubstitutions }
        }
    }
}

/// The `TemplatedPersonalization` class is a subclass of `Personalization`, and
/// is used if you are using the Dynamic Templates feature.
///
/// There is a generic
/// `TemplateData` type that you can specify which represents the substitution
/// data. An example of using this class might look something like this:
///
/// ```
/// // First let's define our dynamic data types:
/// struct CheckoutData: Encodable {
///     let total: String
///     let items: [String]
///     let receipt: Bool
/// }
///
/// // Next let's create the personalization.
/// let thisData = CheckoutData(total: "$239.85",
///                             items: ["Shoes", "Shirt"],
///                             receipt: true)
/// let personalization = TemplatedPersonalization(dynamicTemplateData: thisData,
///                                                recipients: "foo@bar.example")
/// ```
open class TemplatedPersonalization<TemplateData: Encodable>: Personalization {
    // MARK: - Properties
    
    /// The handlebar substitutions that will be applied to the dynamic template
    /// specified in the `templateID` on the `Email`.
    open var dynamicTemplateData: TemplateData
    
    // MARK: - Initialization
    
    /// Initializes the email with all the available properties.
    ///
    /// - Parameters:
    ///   - dynamicTemplateData:    The handlebar substitution data that will be
    ///                             applied to the dynamic template.
    ///   - to:                     An array of addresses to send the email to.
    ///   - cc:                     An array of addresses to add as CC.
    ///   - bcc:                    An array of addresses to add as BCC.
    ///   - subject:                A subject to use in the personalization.
    ///   - headers:                A set of additional headers to add for this
    ///                             personalization. The keys and values in the
    ///                             dictionary should represent the name of the
    ///                             headers and their values, respectively.
    ///   - substitutions:          A set of substitutions to make in this
    ///                             personalization. The keys and values in the
    ///                             dictionary should represent the substitution
    ///                             tags and their replacement values,
    ///                             respectively.
    ///   - customArguments:        A set of custom arguments to add to the
    ///                             personalization. The keys and values in the
    ///                             dictionary should represent the argument
    ///                             names and values, respectively.
    ///   - sendAt:                 A time to send the email at.
    public init(dynamicTemplateData: TemplateData, to: [Address], cc: [Address]? = nil, bcc: [Address]? = nil, subject: String? = nil, headers: [String: String]? = nil, substitutions: [String: String]? = nil, customArguments: [String: String]? = nil, sendAt: Date? = nil) {
        self.dynamicTemplateData = dynamicTemplateData
        super.init(to: to,
                   cc: cc,
                   bcc: bcc,
                   subject: subject,
                   headers: headers,
                   substitutions: substitutions,
                   customArguments: customArguments,
                   sendAt: sendAt)
    }
    
    /// Initializes the personalization with a set of email addresses.
    ///
    /// - Parameters
    ///   - dynamicTemplateData:    The handlebar substitution data that will be
    ///                             applied to the dynamic template.
    ///   - recipients:             A list of email addresses to use as the "to"
    ///                             addresses.
    public convenience init(dynamicTemplateData: TemplateData, recipients: String...) {
        let list: [Address] = recipients.map { Address(email: $0) }
        self.init(dynamicTemplateData: dynamicTemplateData, to: list)
    }
    
    // MARK: - Encodable Conformance
    
    /// :nodoc:
    open override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: TemplatedPersonalization._CodingKeys.self)
        try container.encode(self.dynamicTemplateData, forKey: .dynamicTemplateData)
        try super.encode(to: encoder)
    }
    
    /// :nodoc:
    private enum _CodingKeys: String, CodingKey {
        case dynamicTemplateData = "dynamic_template_data"
    }
}
