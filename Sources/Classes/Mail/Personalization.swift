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
public class Personalization: JSONConvertible, Validatable, HeaderValidator, Scheduling {
    
    // MARK: - Properties
    //=========================================================================
    
    /// An array of recipients to send the email to.
    public let to: [Address]
    
    /// An array of recipients to add as a CC on the email.
    public var cc: [Address]?
    
    /// An array of recipients to add as a BCC on the email.
    public var bcc: [Address]?
    
    /// A personalized subject for the email.
    public var subject: String?
    
    /// An optional set of headers to add to the email in this personalization. Each key in the dictionary should represent the name of the header, and the values of the dictionary should be equal to the values of the headers.
    public var headers: [String:String]?
    
    /// An optional set of substitutions to replace in this personalization. The keys in the dictionary should represent the substitution tags that should be replaced, and the values should be the replacement values.
    public var substitutions: [String:String]?
    
    /// A set of custom arguments to add to the email. The keys of the dictionary should be the names of the custom arguments, while the values should represent the value of each custom argument.
    public var customArguments: [String:String]?
    
    /// An optional time to send the email at.
    public var sendAt: NSDate? = nil
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the personalization.
    public var dictionaryValue: [NSObject : AnyObject] {
        var hash: [NSObject:AnyObject] = [
            "to": self.to.map({ (address) -> [NSObject:AnyObject] in
                return address.dictionaryValue
            })
        ]
        if let carbon = self.cc where carbon.count > 0 {
            hash["cc"] = carbon.map({ (ccs) -> [NSObject:AnyObject] in
                return ccs.dictionaryValue
            })
        }
        if let blind = self.bcc where blind.count > 0 {
            hash["bcc"] = blind.map({ (bccs) -> [NSObject:AnyObject] in
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
        if let args = self.customArguments where args.count > 0 {
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
            return Address(emailAddress: em)
        }
        self.init(to: list)
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the personalization has recipients and that they are proper email addresses as well as making sure the sendAt date is valid.
     
     */
    public func validate() throws {
        if self.to.count <= 0 { throw Error.Mail.MissingRecipients }
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
        if let s = self.subject where s.characters.count == 0 {
            throw Error.Mail.MissingSubject
        }

        if let head = self.headers {
            try self.validateHeaders(head)
        }
        
        if let sub = self.substitutions where sub.count > Constants.SubstitutionLimit {
            throw Error.Mail.TooManySubstitutions
        }
        
        try self.validateSendAt()
    }
    
}