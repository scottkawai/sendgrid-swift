//
//  Personalization.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Personalization` struct is used by the `Email` class to add personalization settings to an email. The only required property is the `to` property, and each email must have at least one personalization.
 
 */
open class Personalization: JSONConvertible, Validatable, HeaderValidator, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// An array of recipients to send the email to.
    open let to: [Address]
    
    /// An array of recipients to add as a CC on the email.
    open var cc: [Address]?
    
    /// An array of recipients to add as a BCC on the email.
    open var bcc: [Address]?
    
    /// A personalized subject for the email.
    open var subject: String?
    
    /// An optional set of headers to add to the email in this personalization. Each key in the dictionary should represent the name of the header, and the values of the dictionary should be equal to the values of the headers.
    open var headers: [String:String]?
    
    /// An optional set of substitutions to replace in this personalization. The keys in the dictionary should represent the substitution tags that should be replaced, and the values should be the replacement values.
    open var substitutions: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the dictionary should be the names of the custom arguments, while the values should represent the value of each custom argument.
    open var customArguments: [String:String]?
    
    /// An optional time to send the email at.
    open var sendAt: Date? = nil
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the personalization.
    open var dictionaryValue: [AnyHashable: Any] {
        var hash: [AnyHashable: Any] = [
            "to": self.to.map({ (address) -> [AnyHashable: Any] in
                return address.dictionaryValue
            })
        ]
        if let carbon = self.cc , carbon.count > 0 {
            hash["cc"] = carbon.map({ (ccs) -> [AnyHashable: Any] in
                return ccs.dictionaryValue
            })
        }
        if let blind = self.bcc , blind.count > 0 {
            hash["bcc"] = blind.map({ (bccs) -> [AnyHashable: Any] in
                return bccs.dictionaryValue
            })
        }
        if let sub = self.subject {
            hash["subject"] = sub
        }
        if let head = self.headers {
            hash["headers"] = head
        }
        if let subs = self.substitutions {
            hash["substitutions"] = subs
        }
        if let args = self.customArguments , args.count > 0 {
            hash["custom_args"] = args
        }
        if let sched = self.sendAt {
            hash["send_at"] = Int(sched.timeIntervalSince1970)
        }
        return hash
    }
    

    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the email with all the available properties.
     
     - parameter to:                An array of addresses to send the email to.
     - parameter cc:                An array of addresses to add as CC.
     - parameter bcc:               An array of addresses to add as BCC.
     - parameter subject:           A subject to use in the personalization.
     - parameter headers:           A set of additional headers to add for this personalization. The keys and values in the dictionary should represent the name of the headers and their values, respectively.
     - parameter substitutions:     A set of substitutions to make in this personalization. The keys and values in the dictionary should represent the substitution tags and their replacement values, respectively.
     - parameter customArguments:   A set of custom arguments to add to the personalization. The keys and values in the dictionary should represent the argument names and values, respectively.
     
     */
    public init(to: [Address], cc: [Address]? = nil, bcc: [Address]? = nil, subject: String? = nil, headers: [String:String]? = nil, substitutions: [String:String]? = nil, customArguments: [String:String]? = nil) {
        self.to = to
        self.cc = cc
        self.bcc = bcc
        self.subject = subject
        self.headers = headers
        self.substitutions = substitutions
        self.customArguments = customArguments
    }
    
    
    /**
     
     Initializes the personalization with a set of email addresses.
     
     - parameter recipients:	A list of email addresses to use as the "to" addresses.
     
     */
    public convenience init(recipients: String...) {
        let list: [Address] = recipients.map { (em) -> Address in
            return Address(em)
        }
        self.init(to: list)
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the personalization has recipients and that they are proper email addresses as well as making sure the sendAt date is valid.
     
     */
    open func validate() throws {
        guard self.to.count > 0 else { throw SGError.Mail.missingRecipients }
        for t in self.to {
            try t.validate()
        }
        if let ccs = self.cc {
            for c in ccs {
                try c.validate()
            }
        }
        if let bccs = self.bcc {
            for b in bccs {
                try b.validate()
            }
        }
        if let s = self.subject {
            guard s.characters.count > 0 else { throw SGError.Mail.missingSubject }
        }

        if let head = self.headers {
            try self.validate(headers: head)
        }
        
        if let sub = self.substitutions {
            guard sub.count <= Constants.SubstitutionLimit else { throw SGError.Mail.tooManySubstitutions }
        }
        
        try self.validateSendAt()
    }
    
}
