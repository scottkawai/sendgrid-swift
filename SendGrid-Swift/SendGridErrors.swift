//
//  SendGridErrors.swift
//  SendGrid
//
//  Created by Scott Kawai on 10/17/15.
//  Copyright © 2015 SendGrid. All rights reserved.
//

import Foundation

public enum SendGridErrors: ErrorType, CustomStringConvertible {
    case BccAddedWithSmtpApi
    case MissingFromAddress
    case MissingRecipients
    case MissingSubject
    
    public var description: String {
        switch self {
        case .BccAddedWithSmtpApi:
            return "The BCC option will not work when specifying recipients in the X-SMTPAPI header. Set the `hasRecipientsInSmtpApi` to false before adding BCC addresses so that the 'To' addresses get added to the normal 'To' header instead of the X-SMTPAPI header."
        case .MissingFromAddress:
            return "Could not send message due to required `from` parameter missing."
        case .MissingRecipients:
            return "Could not send message as no recipients were specified."
        case .MissingSubject:
            return "Could not send message - a subject is required."
        }
    }
}