//
//  BypassListManagement.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `BypassListManagement` class allows you to bypass all unsubscribe groups and suppressions to ensure that the email is delivered to every single recipient. This should only be used in emergencies when it is absolutely necessary that every recipient receives your email. Ex: outage emails, or forgot password emails.
 
 */
open class BypassListManagement: Setting, MailSetting {
    
    // MARK: - Computed Properties
    //=========================================================================

    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        return [
            "bypass_list_management": super.dictionaryValue
        ]
    }
}
