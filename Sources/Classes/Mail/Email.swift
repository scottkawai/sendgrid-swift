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
public class Email: APIV3, Request, JSONConvertible, HeaderValidator, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The endpoint for the API request.
    public var endpoint: String = "v3/mail/send"
    
    /// An array of personalization instances representing the various recipients of the email.
    public let personalizations: [Personalization]
    
    /// The content sections of the email.
    public let content: [Content]
    
    /// The subject of the email. If the personalizations in the email contain subjects, those will override this subject.
    public var subject: String?
    
    /// The sending address on the email.
    public let from: Address
    
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
    public var sections: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the dictionary should be the names of the custom arguments, while the values should represent the value of each custom argument. If personalizations in the email also contain custom arguments, they will be merged with these custom arguments, taking a preference to the personalization's custom arguments in the case of a conflict.
    public var customArguments: [String:String]?
    
    /// An `ASM` instance representing the unsubscribe group settings to apply to the email.
    public var asm: ASM?
    
    /// An optional time to send the email at.
    public var sendAt: NSDate? = nil
    
    /// This ID represents a batch of emails (AKA multiple sends of the same email) to be associated to each other for scheduling. Including a batch_id in your request allows you to include this email in that batch, and also enables you to cancel or pause the delivery of that entire batch. For more information, please read about [Cancel Scheduled Sends](https://sendgrid.com/docs/API_Reference/Web_API_v3/cancel_schedule_send.html).
    public var batchID: String? = nil
    
    /// The IP Pool that you would like to send this email from. See the [docs page](https://sendgrid.com/docs/API_Reference/Web_API_v3/IP_Management/ip_pools.html#-POST) for more information about creating IP Pools.
    public var ipPoolName: String? = nil
    
    /// An optional array of mail settings to configure the email with.
    public var mailSettings: [MailSetting]?
    
    /// An optional array of tracking settings to configure the email with.
    public var trackingSettings: [TrackingSetting]?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The content type for the API request.
    public var contentType: ContentType { return .JSON }
    
    /// The HTTP method used for the API request.
    public var method: HTTPMethod { return .POST }
    
    /// The parameters sent with the API request.
    public var parameters: AnyObject? { return self.dictionaryValue }
    
    /// The dictionary representation of the email.
    public var dictionaryValue: [NSObject : AnyObject] {
        var hash: [NSObject:AnyObject] = [
            "personalizations": self.personalizations.map({ (item) -> [NSObject:AnyObject] in
                return item.dictionaryValue
            }),
            "from": self.from.dictionaryValue,
            "content": self.content.map({ (section) -> [NSObject:AnyObject] in
                return section.dictionaryValue
            })
        ]
        if let sub = self.subject {
            hash["subject"] = sub
        }
        if let reply = self.replyTo {
            hash["reply_to"] = reply.dictionaryValue
        }
        if let files = self.attachments {
            hash["attachments"] = files.map({ (file) -> [NSObject:AnyObject] in
                return file.dictionaryValue
            })
        }
        if let template = self.templateID where template.characters.count > 0 {
            hash["template_id"] = template
        }
        if let sec = self.sections where sec.count > 0 {
            hash["sections"] = sec
        }
        if let head = self.headers where head.count > 0 {
            hash["headers"] = head
        }
        if let cats = self.categories where cats.count > 0 {
            var deduped = [String:Bool]()
            for cat in cats {
                deduped[cat] = true
            }
            hash["categories"] = Array(deduped.keys)
        }
        if let args = self.customArguments where args.count > 0 {
            hash["custom_args"] = args
        }
        if let a = self.asm {
            hash["asm"] = a.dictionaryValue
        }
        if let sched = self.sendAt {
            hash["send_at"] = Int(sched.timeIntervalSince1970)
        }
        if let batch = self.batchID where batch.characters.count > 0 {
            hash["batch_id"] = batch
        }
        if let pool = self.ipPoolName where pool.characters.count > 0 {
            hash["ip_pool_name"] = pool
        }
        if let ms = self.mailSettings {
            hash["mail_settings"] = ms.reduce([NSObject:AnyObject](), combine: { (current, setting) -> [NSObject:AnyObject] in
                var updated = current
                for (key, value) in setting.dictionaryValue {
                    updated[key] = value
                }
                return updated
            })
        }
        if let ts = self.trackingSettings {
            hash["tracking_settings"] = ts.reduce([NSObject:AnyObject](), combine: { (current, setting) -> [NSObject:AnyObject] in
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
    public func validate() throws {
        
        // Check for correct amount of personalizations
        if self.personalizations.count == 0 || self.personalizations.count > Constants.PersonalizationLimit {
            throw Error.Mail.InvalidNumberOfPersonalizations
        }
        
        // Check for content
        if self.content.count == 0 {
            throw Error.Mail.MissingContent
        }
        
        // Check for content order
        var isOrdered = true
        var previousIndex = 0
        for item in self.content {
            try item.validate()
            isOrdered = isOrdered && (item.type.index >= previousIndex)
            previousIndex = item.type.index
        }
        if !isOrdered {
            throw Error.Mail.InvalidContentOrder
        }
        
        // Check for total number of recipients
        var totalRecipients: [String] = []
        for per in self.personalizations {
            for t in per.to {
                if let _ = totalRecipients.indexOf(t.email.lowercaseString) {
                    throw Error.Mail.DuplicateRecipient(t.email)
                } else {
                    totalRecipients.append(t.email.lowercaseString)
                }
            }
            
            if let ccs = per.cc {
                for c in ccs {
                    if let _ = totalRecipients.indexOf(c.email.lowercaseString) {
                        throw Error.Mail.DuplicateRecipient(c.email)
                    } else {
                        totalRecipients.append(c.email.lowercaseString)
                    }
                }
            }
            
            if let bccs = per.bcc {
                for b in bccs {
                    if let _ = totalRecipients.indexOf(b.email.lowercaseString) {
                        throw Error.Mail.DuplicateRecipient(b.email)
                    } else {
                        totalRecipients.append(b.email.lowercaseString)
                    }
                }
            }
            
            try per.validate()
        }
        
        if totalRecipients.count > Constants.RecipientLimit {
            throw Error.Mail.TooManyRecipients
        }
        
        // Check for subject present
        if ((self.subject?.characters.count ?? 0) == 0) && self.templateID == nil {
            let subjectPresent = self.personalizations.reduce(true) { (hasSubject, person) -> Bool in
                return hasSubject && ((person.subject?.characters.count ?? 0) > 0)
            }
            if !subjectPresent {
                throw Error.Mail.MissingSubject
            }
        }
        
        // Validate from address
        try self.from.validate()
        
        // Validate reply-to address
        try self.replyTo?.validate()
        
        // Validate the headers
        if let head = self.headers {
            try self.validateHeaders(head)
        }
        
        // Validate the categories
        if let cats = self.categories {
            if cats.count > Constants.Categories.TotalLimit {
                throw Error.Mail.TooManyCategories
            }
            for cat in cats {
                if cat.characters.count > Constants.Categories.CharacterLimit {
                    throw Error.Mail.CategoryTooLong(cat)
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
            let bytes = ParameterEncoding.JSON(merged).data?.length ?? 0
            if bytes > Constants.CustomArguments.MaximumBytes {
                throw Error.Mail.TooManyCustomArguments(bytes, ParameterEncoding.JSON(merged).stringValue)
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
    public override func requestForSession(session: Session, onBehalfOf: String?) throws -> NSMutableURLRequest {
        if let auth = session.authentication where auth.description == "credential" {
            throw Error.Session.AuthenticationTypeNotAllowed(self.dynamicType, auth)
        }
        
        if let _ = onBehalfOf { throw Error.Request.ImpersonationNotSupported(self.dynamicType) }
        
        return try super.requestForSession(session, onBehalfOf: onBehalfOf)
    }
}