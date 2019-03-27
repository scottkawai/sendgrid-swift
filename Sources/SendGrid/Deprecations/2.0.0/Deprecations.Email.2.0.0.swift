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
    var personalizations: [Personalization] {
        get { return self.parameters!.personalizations }
        set { self.parameters?.personalizations = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.content")
    var content: [Content] {
        get { return self.parameters!.content }
        set { self.parameters?.content = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.subject")
    var subject: String? {
        get { return self.parameters!.subject }
        set { self.parameters?.subject = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.from")
    var from: Address {
        get { return self.parameters!.from }
        set { self.parameters?.from = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.replyTo")
    var replyTo: Address? {
        get { return self.parameters!.replyTo }
        set { self.parameters?.replyTo = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.attachments")
    var attachments: [Attachment]? {
        get { return self.parameters!.attachments }
        set { self.parameters?.attachments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.templateID")
    var templateID: String? {
        get { return self.parameters!.templateID }
        set { self.parameters?.templateID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.categories")
    var categories: [String]? {
        get { return self.parameters!.categories }
        set { self.parameters?.categories = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sections")
    var sections: [String: String]? {
        get { return self.parameters!.sections }
        set { self.parameters?.sections = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.customArguments")
    var customArguments: [String: String]? {
        get { return self.parameters!.customArguments }
        set { self.parameters?.customArguments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.asm")
    var asm: ASM? {
        get { return self.parameters!.asm }
        set { self.parameters?.asm = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sendAt")
    var sendAt: Date? {
        get { return self.parameters!.sendAt }
        set { self.parameters?.sendAt = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.batchID")
    var batchID: String? {
        get { return self.parameters!.batchID }
        set { self.parameters?.batchID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.ipPoolName")
    var ipPoolName: String? {
        get { return self.parameters!.ipPoolName }
        set { self.parameters?.ipPoolName = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.mailSettings")
    var mailSettings: MailSettings {
        get { return self.parameters!.mailSettings }
        set { self.parameters?.mailSettings = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.trackingSettings")
    var trackingSettings: TrackingSettings {
        get { return self.parameters!.trackingSettings }
        set { self.parameters?.trackingSettings = newValue }
    }
}
