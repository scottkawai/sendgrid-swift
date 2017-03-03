//
//  SubscriptionTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `SubscriptionTracking` class is used to modify the subscription tracking setting on an email.
 
 */
open class SubscriptionTracking: Setting, TrackingSetting, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /**
     
     Text to be appended to the email, with the subscription tracking link. You may control where the link is by using the tag `<% %>`. For example:
     
     ```
     If you would like to unsubscribe and stop receiving these emails click here: <% %>.
     ```
     
     */
    open let text: String
    
    /**
     
     HTML to be appended to the email, with the subscription tracking link. You may control where the link is by using the tag `<% %>`. For example:
     
     ```
     <p>If you would like to unsubscribe and stop receiving these emails <% click here %>.</p>
     ```
     
     */
    open let html: String
    
    /**
     
     A tag that will be replaced with the unsubscribe URL. For example: `[unsubscribe_url]`. If this parameter is used, it will override both the `text` and `html` parameters. The URL of the link will be placed at the substitution tag's location, with no additional formatting.
     
     */
    open let substitutionTag: String?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        if let sub = self.substitutionTag {
            hash["substitution_tag"] = sub
        }
        hash["text"] = self.text
        hash["html"] = self.html
        return [
            "subscription_tracking": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the setting with verbiage for the plain text and HTML versions of an email. Both of these parameter must contain a `<% %>` tag which indicates where the unsubscribe URL should be placed, otherwise an error is thrown.
     
     - parameter enable:            A boolean indicating whether the setting should be on or off.
     - parameter plainText:         Text to be appended to the email, with the subscription tracking link. You may control where the link is by using the tag `<% %>`.
     - parameter HTML:              HTML to be appended to the email, with the subscription tracking link. You may control where the link is by using the tag `<% %>`.
     - parameter substitutionTag:   An optional tag to indicate where to place the unsubscribe URL.
     
     */
    public init(enable: Bool, plainText: String = Constants.SubscriptionTracking.DefaultPlainText, HTML: String = Constants.SubscriptionTracking.DefaultHTMLText, substitutionTag: String? = nil) {
        self.text = plainText
        self.html = HTML
        self.substitutionTag = substitutionTag
        super.init(enable: enable)
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the plain text and HTML text contain the proper tag.
     
     */
    open func validate() throws {
        guard Validator.subscriptionTrackingText(self.text).valid
            && Validator.subscriptionTrackingText(self.html).valid else {
            throw SGError.Mail.missingSubscriptionTrackingTag
        }
    }
    
}
