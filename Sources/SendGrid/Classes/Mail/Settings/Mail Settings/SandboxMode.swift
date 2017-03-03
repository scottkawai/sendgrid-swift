//
//  SandboxMode.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 This allows you to send a test email to ensure that your request body is valid and formatted correctly. For more information, please see the [SendGrid docs](https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/sandbox_mode.html).
 
 */
open class SandboxMode: Setting, MailSetting {
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        return [
            "sandbox_mode": super.dictionaryValue
        ]
    }
    
}
