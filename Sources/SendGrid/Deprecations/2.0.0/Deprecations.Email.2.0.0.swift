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
    public var personalizations: [Personalization] {
        get { return self.parameters!.personalizations }
        set { self.parameters?.personalizations = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.content")
    public var content: [Content] {
        get { return self.parameters!.content }
        set { self.parameters?.content = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.subject")
    public var subject: String? {
        get { return self.parameters!.subject }
        set { self.parameters?.subject = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.from")
    public var from: Address {
        get { return self.parameters!.from }
        set { self.parameters?.from = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.replyTo")
    public var replyTo: Address? {
        get { return self.parameters!.replyTo }
        set { self.parameters?.replyTo = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.attachments")
    public var attachments: [Attachment]? {
        get { return self.parameters!.attachments }
        set { self.parameters?.attachments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.templateID")
    public var templateID: String? {
        get { return self.parameters!.templateID }
        set { self.parameters?.templateID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.categories")
    public var categories: [String]? {
        get { return self.parameters!.categories }
        set { self.parameters?.categories = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sections")
    public var sections: [String:String]? {
        get { return self.parameters!.sections }
        set { self.parameters?.sections = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.customArguments")
    public var customArguments: [String:String]? {
        get { return self.parameters!.customArguments }
        set { self.parameters?.customArguments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.asm")
    public var asm: ASM? {
        get { return self.parameters!.asm }
        set { self.parameters?.asm = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sendAt")
    public var sendAt: Date? {
        get { return self.parameters!.sendAt }
        set { self.parameters?.sendAt = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.batchID")
    public var batchID: String? {
        get { return self.parameters!.batchID }
        set { self.parameters?.batchID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.ipPoolName")
    public var ipPoolName: String? {
        get { return self.parameters!.ipPoolName }
        set { self.parameters?.ipPoolName = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.mailSettings")
    public var mailSettings: MailSettings {
        get { return self.parameters!.mailSettings }
        set { self.parameters?.mailSettings = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.trackingSettings")
    public var trackingSettings: TrackingSettings{
        get { return self.parameters!.trackingSettings }
        set { self.parameters?.trackingSettings = newValue }
    }
    
}
