import Foundation

public extension Email {
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.personalizations")
    var personalizations: [Personalization] {
        get { self.parameters!.personalizations }
        set { self.parameters?.personalizations = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.content")
    var content: [Content] {
        get { self.parameters!.content! }
        set { self.parameters?.content = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.subject")
    var subject: String? {
        get { self.parameters!.subject }
        set { self.parameters?.subject = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.from")
    var from: Address {
        get { self.parameters!.from }
        set { self.parameters?.from = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.replyTo")
    var replyTo: Address? {
        get { self.parameters!.replyTo }
        set { self.parameters?.replyTo = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.attachments")
    var attachments: [Attachment]? {
        get { self.parameters!.attachments }
        set { self.parameters?.attachments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.templateID")
    var templateID: String? {
        get { self.parameters!.templateID }
        set { self.parameters?.templateID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.categories")
    var categories: [String]? {
        get { self.parameters!.categories }
        set { self.parameters?.categories = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sections")
    var sections: [String: String]? {
        get { self.parameters!.sections }
        set { self.parameters?.sections = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.customArguments")
    var customArguments: [String: String]? {
        get { self.parameters!.customArguments }
        set { self.parameters?.customArguments = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.asm")
    var asm: ASM? {
        get { self.parameters!.asm }
        set { self.parameters?.asm = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.sendAt")
    var sendAt: Date? {
        get { self.parameters!.sendAt }
        set { self.parameters?.sendAt = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.batchID")
    var batchID: String? {
        get { self.parameters!.batchID }
        set { self.parameters?.batchID = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.ipPoolName")
    var ipPoolName: String? {
        get { self.parameters!.ipPoolName }
        set { self.parameters?.ipPoolName = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.mailSettings")
    var mailSettings: MailSettings {
        get { self.parameters!.mailSettings }
        set { self.parameters?.mailSettings = newValue }
    }
    
    /// :nodoc:
    @available(*, deprecated, renamed: "parameters.trackingSettings")
    var trackingSettings: TrackingSettings {
        get { self.parameters!.trackingSettings }
        set { self.parameters?.trackingSettings = newValue }
    }
}
