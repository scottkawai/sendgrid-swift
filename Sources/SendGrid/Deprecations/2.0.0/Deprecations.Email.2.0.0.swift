//
//  Deprecations.Email.2.0.0.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/21/18.
//

import Foundation

public extension Email {
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.personalizations")
    public var personalizations: [Personalization] { return [] }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.content")
    public var content: [Content] { return [] }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.subject")
    public var subject: String? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.from")
    public var from: Address { return Address(email: "") }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.replyTo")
    public var replyTo: Address? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.attachments")
    public var attachments: [Attachment]? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.templateID")
    public var templateID: String? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.categories")
    public var categories: [String]? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sections")
    public var sections: [String:String]? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.customArguments")
    public var customArguments: [String:String]? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.asm")
    public var asm: ASM? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sendAt")
    public var sendAt: Date? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.batchID")
    public var batchID: String? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.ipPoolName")
    public var ipPoolName: String? { return nil }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.mailSettings")
    public var mailSettings: MailSettings { return MailSettings() }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.trackingSettings")
    public var trackingSettings: TrackingSettings { return TrackingSettings() }
    
}
