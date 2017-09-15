//
//  MailSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `MailSetting` protocol represents the properties needed for a class to
/// represent a mail setting.
public protocol MailSetting: Encodable {
    
    /// A bool indicating if the setting should be toggle on or off.
    var enable: Bool { get }
    
}
