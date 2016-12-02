//
//  Email.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Email` class represents an email message to send through the SendGrid API.
 
 */
open class Email: APIV3, Request, JSONConvertible, HeaderValidator, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The endpoint for the API request.
    open var endpoint: String = "v3/mail/send"
    
    /// An array of personalization instances representing the various recipients of the email.
    open let personalizations: [Personalization]
    
    /// The content sections of the email.
    open let content: [Content]
    
    /// The subject of the email. If the personalizations in the email contain subjects, those will override this subject.
    open var subject: String?
    
    /// The sending address on the email.
    open let from: Address
    
    /// The reply to address on the email.
    open var replyTo: Address?
    
    /// Attachments to add to the email.
    open var attachments: [Attachment]?
    
    /// The ID of a template from the Template Engine to use with the email.
    open var templateID: String?
    
    /// Additional headers that should be added to the email.
    open var headers: [String:String]?
    
    /// Categories to associate with the email.
    open var categories: [String]?
    
    /// A dictionary of key/value pairs that define large blocks of content that can be inserted into your emails using substitution tags. An example of this might look like the following:
    ///
    /// ```
    /// let bob = Personalization(recipients: "bob@example.com")
    /// bob.substitutions = [
    ///     ":salutation": ":male",
    ///     ":name": "Bob",
    ///     ":event_details": "event2",
    ///     ":event_date": "Feb 14"
    /// ]
    ///
    /// let alice = Personalization(recipients: "alice@example.com")
    /// alice.substitutions = [
    ///     ":salutation": ":female",
    ///     ":name": "Alice",
    ///     ":event_details": "event1",
    ///     ":event_date": "Jan 1"
    /// ]
    ///
    /// let casey = Personalization(recipients: "casey@example.com")
    /// casey.substitutions = [
    ///     ":salutation": ":neutral",
    ///     ":name": "Casey",
    ///     ":event_details": "event1",
    ///     ":event_date": "Aug 11"
    /// ]
    ///
    /// let personalization = [
    ///     bob,
    ///     alice,
    ///     casey
    /// ]
    /// let plainText = ":salutation,\n\nPlease join us for the :event_details."
    /// let htmlText = "<p>:salutation,</p><p>Please join us for the :event_details.</p>"
    /// let content = Content.emailContent(plain: plainText, html: htmlText)
    /// let email = Email(personalizations: personalization, from: Address(emailAddress: "from@example.com"), content: content)
    /// email.subject = "Hello World"
    /// email.sections = [
    ///     ":male": "Mr. :name",
    ///     ":female": "Ms. :name",
    ///     ":neutral": ":name",
    ///     ":event1": "New User Event on :event_date",
    ///     ":event2": "Veteran User Appreciation on :event_date"
    /// ]
    /// ```
    open var sections: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the dictionary should be the names of the custom arguments, while the values should represent the value of each custom argument. If personalizations in the email also contain custom arguments, they will be merged with these custom arguments, taking a preference to the personalization's custom arguments in the case of a conflict.
    open var customArguments: [String:String]?
    
    /// An `ASM` instance representing the unsubscribe group settings to apply to the email.
    open var asm: ASM?
    
    /// An optional time to send the email at.
    open var sendAt: Date? = nil
    
    /// This ID represents a batch of emails (AKA multiple sends of the same email) to be associated to each other for scheduling. Including a batch_id in your request allows you to include this email in that batch, and also enables you to cancel or pause the delivery of that entire batch. For more information, please read about [Cancel Scheduled Sends](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html).
    open var batchID: String? = nil
    
    /// The IP Pool that you would like to send this email from. See the [docs page](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html#-POST) for more information about creating IP Pools.
    open var ipPoolName: String? = nil
    
    /// An optional array of mail settings to configure the email with.
    open var mailSettings: [MailSetting]?
    
    /// An optional array of tracking settings to configure the email with.
    open var trackingSettings: [TrackingSetting]?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The content type for the API request.
    open var contentType: ContentType { return .json }
    
    /// The HTTP method used for the API request.
    open var method: HTTPMethod { return .POST }
    
    /// The parameters sent with the API request.
    open var parameters: [AnyHashable:Any]? { return self.dictionaryValue }
    
    /// The dictionary representation of the email.
    open var dictionaryValue: [AnyHashable: Any] {
        var hash: [String: Any] = [
            "personalizations": self.personalizations.map({ (item) -> [AnyHashable: Any] in
                return item.dictionaryValue
            }),
            "from": self.from.dictionaryValue,
            "content": self.content.map({ (section) -> [AnyHashable: Any] in
                return section.dictionaryValue
            })
        ]
        if let sub = self.subject {
            hash["subject"] = sub
        }
        if let reply = self.replyTo {
            hash["reply_to"] = reply.dictionaryValue
        }
        if let files = self.attachments, files.count > 0 {
            hash["attachments"] = files.map({ (file) -> [AnyHashable: Any] in
                return file.dictionaryValue
            })
        }
        if let template = self.templateID , template.characters.count > 0 {
            hash["template_id"] = template
        }
        if let sec = self.sections , sec.count > 0 {
            hash["sections"] = sec
        }
        if let head = self.headers , head.count > 0 {
            hash["headers"] = head
        }
        if let cats = self.categories , cats.count > 0 {
            var deduped = [String:Bool]()
            for cat in cats {
                deduped[cat] = true
            }
            hash["categories"] = Array(deduped.keys)
        }
        if let args = self.customArguments , args.count > 0 {
            hash["custom_args"] = args
        }
        if let a = self.asm {
            hash["asm"] = a.dictionaryValue
        }
        if let sched = self.sendAt {
            hash["send_at"] = Int(sched.timeIntervalSince1970)
        }
        if let batch = self.batchID , batch.characters.count > 0 {
            hash["batch_id"] = batch
        }
        if let pool = self.ipPoolName , pool.characters.count > 0 {
            hash["ip_pool_name"] = pool
        }
        if let ms = self.mailSettings, ms.count > 0 {
            hash["mail_settings"] = ms.reduce([AnyHashable: Any](), { (current, setting) -> [AnyHashable: Any] in
                var updated = current
                for (key, value) in setting.dictionaryValue {
                    updated[key] = value
                }
                return updated
            })
        }
        if let ts = self.trackingSettings, ts.count > 0 {
            hash["tracking_settings"] = ts.reduce([AnyHashable: Any](), { (current, setting) -> [AnyHashable: Any] in
                var updated = current
                for (key, value) in setting.dictionaryValue {
                    updated[key] = value
                }
                return updated
            })
        }
        return hash
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the email with an array of personalizations, a subject, and content.
     
     - parameter personalizations:	An array of personalizations. There must be at least 1 in the array, and the array cannot contain more than 25 personalizations.
     - parameter subject:           The subject of the email.
     - parameter content:           An array of `Content` instances representing the body of the email.
     
     */
    public init(personalizations: [Personalization], from: Address, content: [Content], subject: String? = nil) {
        self.subject = subject
        self.personalizations = personalizations
        self.from = from
        self.content = content
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates the email and throws any errors if necessary.
     
     */
    open func validate() throws {
        
        // Check for correct amount of personalizations
        guard (1...Constants.PersonalizationLimit).contains(self.personalizations.count) else {
            throw SGError.Mail.invalidNumberOfPersonalizations
        }
        
        // Check for content
        guard self.content.count > 0 else { throw SGError.Mail.missingContent }
        
        // Check for content order
        var isOrdered = true
        var previousIndex = 0
        for item in self.content {
            try item.validate()
            isOrdered = isOrdered && (item.type.index >= previousIndex)
            previousIndex = item.type.index
        }
        guard isOrdered else { throw SGError.Mail.invalidContentOrder }
        
        // Check for total number of recipients
        var totalRecipients: [String] = []
        for per in self.personalizations {
            for t in per.to {
                if let _ = totalRecipients.index(of: t.email.lowercased()) {
                    throw SGError.Mail.duplicateRecipient(t.email)
                } else {
                    totalRecipients.append(t.email.lowercased())
                }
            }
            
            if let ccs = per.cc {
                for c in ccs {
                    if let _ = totalRecipients.index(of: c.email.lowercased()) {
                        throw SGError.Mail.duplicateRecipient(c.email)
                    } else {
                        totalRecipients.append(c.email.lowercased())
                    }
                }
            }
            
            if let bccs = per.bcc {
                for b in bccs {
                    if let _ = totalRecipients.index(of: b.email.lowercased()) {
                        throw SGError.Mail.duplicateRecipient(b.email)
                    } else {
                        totalRecipients.append(b.email.lowercased())
                    }
                }
            }
            
            try per.validate()
        }
        
        guard totalRecipients.count <= Constants.RecipientLimit else { throw SGError.Mail.tooManyRecipients }
        
        // Check for subject present
        if ((self.subject?.characters.count ?? 0) == 0) && self.templateID == nil {
            let subjectPresent = self.personalizations.reduce(true) { (hasSubject, person) -> Bool in
                return hasSubject && ((person.subject?.characters.count ?? 0) > 0)
            }
            guard subjectPresent else { throw SGError.Mail.missingSubject }
        }
        
        // Validate from address
        try self.from.validate()
        
        // Validate reply-to address
        try self.replyTo?.validate()
        
        // Validate the headers
        if let head = self.headers {
            try self.validate(headers: head)
        }
        
        // Validate the categories
        if let cats = self.categories {
            guard cats.count <= Constants.Categories.TotalLimit else { throw SGError.Mail.tooManyCategories }
            for cat in cats {
                guard cat.characters.count <= Constants.Categories.CharacterLimit else {
                    throw SGError.Mail.categoryTooLong(cat)
                }
            }
        }
        
        // Validate the custom arguments.
        for p in self.personalizations {
            var merged = self.customArguments ?? [:]
            if let list = p.customArguments {
                for (key, value) in list {
                    merged[key] = value
                }
            }
            let bytes = ParameterEncoding.jsonData(from: merged)?.count ?? 0
            guard bytes <= Constants.CustomArguments.MaximumBytes else {
                throw SGError.Mail.tooManyCustomArguments(bytes, ParameterEncoding.jsonString(from: merged))
            }
        }
        
        // Validate ASM
        try self.asm?.validate()
        
        // Validate the send at date.
        try self.validateSendAt()
        
    }
    
    /**
     
     Returns a configured NSMutableURLRequest with the proper authenticaiton information.
     
     - parameter session:       The session instance that will facilitate the HTTP request.
     - parameter onBehalfOf:    The username of a subuser to make the request on behalf of.
     
     - returns: A NSMutableURLRequest with all the proper properties and authentication information set.
     
     */
    open override func request(for session: Session, onBehalfOf: String?) throws -> URLRequest {
        if let auth = session.authentication , auth.description == "credential" {
            throw SGError.Session.authenticationTypeNotAllowed(type(of: self), auth)
        }
        
        if let _ = onBehalfOf { throw SGError.Request.impersonationNotSupported(type(of: self)) }
        
        return try super.request(for: session, onBehalfOf: onBehalfOf)
    }
}
