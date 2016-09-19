//
//  Footer.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Footer` mail setting allows you to specify a footer that will be appended to the bottom of every email.
 
 */
open class Footer: Setting, MailSetting {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The plain text content of your footer.
    open let text: String
    
    /// The HTML content of your footer.
    open let html: String
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        hash["text"] = self.text
        hash["html"] = self.html
        return [
            "footer": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the setting with plain text and HTML to use in the footer.
     
     - parameter enable:    A bool indicating if the setting should be on or off.
     - parameter text:      The plain text content of your footer.
     - parameter html:      The HTML content of your footer.
     
     */
    public init(enable: Bool, text: String, html: String) {
        self.text = text
        self.html = html
        super.init(enable: enable)
    }
    
}
