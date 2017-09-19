//
//  Email.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/17/17.
//

import Foundation

public class Email: Request<[String:Any]>, EmailHeaderRepresentable, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A `Bool` indicating if the request supports the "On-behalf-of" header.
    public override var supportsImpersonation: Bool { return false }
    
    /// An array of personalization instances representing the various
    /// recipients of the email.
    public var personalizations: [Personalization]
    
    /// The content sections of the email.
    public var content: [Content]
    
    /// The subject of the email. If the personalizations in the email contain
    /// subjects, those will override this subject.
    public var subject: String?
    
    /// The sending address on the email.
    public var from: Address
    
    /// The reply to address on the email.
    public var replyTo: Address?
    
    /// Attachments to add to the email.
    public var attachments: [Attachment]?
    
    /// The ID of a template from the Template Engine to use with the email.
    public var templateID: String?
    
    /// Additional headers that should be added to the email.
    public var headers: [String:String]?
    
    /// Categories to associate with the email.
    public var categories: [String]?
    
    /// A dictionary of key/value pairs that define large blocks of content that
    /// can be inserted into your emails using substitution tags. An example of
    /// this might look like the following:
    ///
    ///     let bob = Personalization(recipients: "bob@example.com")
    ///     bob.substitutions = [
    ///         ":salutation": ":male",
    ///         ":name": "Bob",
    ///         ":event_details": "event2",
    ///         ":event_date": "Feb 14"
    ///     ]
    ///
    ///     let alice = Personalization(recipients: "alice@example.com")
    ///     alice.substitutions = [
    ///         ":salutation": ":female",
    ///         ":name": "Alice",
    ///         ":event_details": "event1",
    ///         ":event_date": "Jan 1"
    ///     ]
    ///
    ///     let casey = Personalization(recipients: "casey@example.com")
    ///     casey.substitutions = [
    ///         ":salutation": ":neutral",
    ///         ":name": "Casey",
    ///         ":event_details": "event1",
    ///         ":event_date": "Aug 11"
    ///     ]
    ///
    ///     let personalization = [
    ///         bob,
    ///         alice,
    ///         casey
    ///     ]
    ///     let plainText = ":salutation,\n\nPlease join us for the :event_details."
    ///     let htmlText = "<p>:salutation,</p><p>Please join us for the :event_details.</p>"
    ///     let content = Content.emailBody(plain: plainText, html: htmlText)
    ///     let email = Email(
    ///         personalizations: personalization,
    ///         from: Address(emailAddress: "from@example.com"),
    ///         content: content
    ///     )
    ///     email.subject = "Hello World"
    ///     email.sections = [
    ///         ":male": "Mr. :name",
    ///         ":female": "Ms. :name",
    ///         ":neutral": ":name",
    ///         ":event1": "New User Event on :event_date",
    ///         ":event2": "Veteran User Appreciation on :event_date"
    ///     ]
    public var sections: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the
    /// dictionary should be the names of the custom arguments, while the values
    /// should represent the value of each custom argument. If personalizations
    /// in the email also contain custom arguments, they will be merged with
    /// these custom arguments, taking a preference to the personalization's
    /// custom arguments in the case of a conflict.
    public var customArguments: [String:String]?
    
    /// An `ASM` instance representing the unsubscribe group settings to apply
    /// to the email.
    public var asm: ASM?
    
    /// An optional time to send the email at.
    public var sendAt: Date? = nil
    
    /// This ID represents a batch of emails (AKA multiple sends of the same
    /// email) to be associated to each other for scheduling. Including a
    /// `batch_id` in your request allows you to include this email in that
    /// batch, and also enables you to cancel or pause the delivery of that
    /// entire batch. For more information, please read about [Cancel Scheduled
    /// Sends](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html).
    public var batchID: String? = nil
    
    /// The IP Pool that you would like to send this email from. See the [docs
    /// page](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html#-POST)
    /// for more information about creating IP Pools.
    public var ipPoolName: String? = nil
    
    /// An optional array of mail settings to configure the email with.
    public var mailSettings = MailSettings()
    
    /// An optional array of tracking settings to configure the email with.
    public var trackingSettings = TrackingSettings()
    
    // MARK: - Initialization
    //=========================================================================
    
    public init(personalizations: [Personalization], from: Address, content: [Content], subject: String? = nil) {
        self.personalizations = personalizations
        self.from = from
        self.content = content
        self.subject = subject
        super.init(method: .POST, contentType: .json, path: "/v3/mail/send")
    }
    
    // MARK: - Methods
    //=========================================================================
    
    /// Validates all the email properties and bubbles up errors.
    public override func validate() throws {
        try super.validate()
        
        // Check for correct amount of personalizations
        guard 1...Constants.PersonalizationLimit ~= self.personalizations.count else {
            throw Exception.Mail.invalidNumberOfPersonalizations
        }
        
        // Check for content
        guard self.content.count > 0 else { throw Exception.Mail.missingContent }
        
        // Check for content order
        let (isOrdered, _) = try self.content.reduce((true, 0)) { (running, item) -> (Bool, Int) in
            try item.validate()
            let thisIsOrdered = running.0 && (item.type.index >= running.1)
            return (thisIsOrdered, item.type.index)
        }
        guard isOrdered else { throw Exception.Mail.invalidContentOrder }
        
        // Check for total number of recipients
        let totalRecipients: [String] = try self.personalizations.reduce([String]()) { (list, per) -> [String] in
            try per.validate()
            func reduce(addresses: [Address]?) throws -> [String] {
                guard let array = addresses else { return [] }
                return try array.reduce([String](), { (running, address) -> [String] in
                    if list.contains(address.email.lowercased()) {
                        throw Exception.Mail.duplicateRecipient(address.email.lowercased())
                    }
                    return running + [address.email.lowercased()]
                })
            }
            let tos = try reduce(addresses: per.to)
            let ccs = try reduce(addresses: per.cc)
            let bcc = try reduce(addresses: per.bcc)
            return list + tos + ccs + bcc
        }
        guard totalRecipients.count <= Constants.RecipientLimit else { throw Exception.Mail.tooManyRecipients }
        
        // Check for subject present
        if ((self.subject?.count ?? 0) == 0) && self.templateID == nil {
            let subjectPresent = self.personalizations.reduce(true) { (hasSubject, person) -> Bool in
                return hasSubject && ((person.subject?.count ?? 0) > 0)
            }
            guard subjectPresent else { throw Exception.Mail.missingSubject }
        }
        
        // Validate from address
        try self.from.validate()
        
        // Validate reply-to address
        try self.replyTo?.validate()
        
        // Validate the headers
        try self.validateHeaders()
        
        // Validate the categories
        if let cats = self.categories {
            guard cats.count <= Constants.Categories.TotalLimit else { throw Exception.Mail.tooManyCategories }
            _ = try cats.reduce([String](), { (list, cat) -> [String] in
                guard cat.count <= Constants.Categories.CharacterLimit else {
                    throw Exception.Mail.categoryTooLong(cat)
                }
                let lower = cat.lowercased()
                if list.contains(lower) {
                    throw Exception.Mail.duplicateCategory(lower)
                }
                return list + [lower]
            })
        }
        
        // Validate the custom arguments.
        try self.personalizations.forEach({ (p) in
            var merged = self.customArguments ?? [:]
            if let list = p.customArguments {
                list.forEach { merged[$0.key] = $0.value }
            }
            let jsonData = try JSONEncoder().encode(merged)
            let bytes = jsonData.count
            guard bytes <= Constants.CustomArguments.MaximumBytes else {
                let jsonString = String(data: jsonData, encoding: .utf8)
                throw Exception.Mail.tooManyCustomArguments(bytes, jsonString)
            }
        })
        
        // Validate ASM
        try self.asm?.validate()
        
        // Validate the send at date.
        try self.validateSendAt()
        
        // Validate the mail settings.
        try self.mailSettings.validate()
        
        // validate the tracking settings.
        try self.trackingSettings.validate()
    }
    
    /// Before a `Session` instance makes an API call, it will call this method
    /// to double check that the auth method it's about to use is supported by
    /// the endpoint. In general, this will always return `true`, however some
    /// endpoints, such as the mail send endpoint, only support API keys.
    ///
    /// - Parameter auth:   The `Authentication` instance that's about to be
    ///                     used.
    /// - Returns:          A `Bool` indicating if the authentication method is
    ///                     supported.
    public override func supports(auth: Authentication) -> Bool {
        // The mail send endpoint only supports API Keys.
        return auth.prefix == "Bearer"
    }
}

/// Encodable conformance.
extension Email: AutoEncodable {
    
    public enum CodingKeys: String, CodingKey {
        case asm
        case attachments
        case batchID            = "batch_id"
        case categories
        case content
        case customArguments    = "custom_args"
        case from
        case headers
        case ipPoolName         = "ip_pool_name"
        case mailSettings       = "mail_settings"
        case personalizations
        case replyTo            = "reply_to"
        case sections
        case sendAt             = "send_at"
        case subject
        case templateID         = "template_id"
        case trackingSettings   = "tracking_settings"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.personalizations, forKey: .personalizations)
        try container.encode(self.from, forKey: .from)
        try container.encode(self.content, forKey: .content)
        try container.encodeIfPresent(self.subject, forKey: .subject)
        try container.encodeIfPresent(self.replyTo, forKey: .replyTo)
        try container.encodeIfPresent(self.attachments, forKey: .attachments)
        try container.encodeIfPresent(self.templateID, forKey: .templateID)
        try container.encodeIfPresent(self.sections, forKey: .sections)
        try container.encodeIfPresent(self.headers, forKey: .headers)
        try container.encodeIfPresent(self.categories, forKey: .categories)
        try container.encodeIfPresent(self.customArguments, forKey: .customArguments)
        try container.encodeIfPresent(self.asm, forKey: .asm)
        try container.encodeIfPresent(self.sendAt, forKey: .sendAt)
        try container.encodeIfPresent(self.batchID, forKey: .batchID)
        try container.encodeIfPresent(self.ipPoolName, forKey: .ipPoolName)
        if self.mailSettings.hasSettings {
            try container.encode(self.mailSettings, forKey: .mailSettings)
        }
        if self.trackingSettings.hasSettings {
            try container.encode(self.trackingSettings, forKey: .trackingSettings)
        }
    }
    
}
