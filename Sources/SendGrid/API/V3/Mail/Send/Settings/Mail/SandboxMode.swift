//
//  SandboxMode.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// This allows you to send a test email to ensure that your request body is
/// valid and formatted correctly. For more information, please see the
/// [SendGrid docs](https://sendgrid.com/docs/Classroom/Send/v3_Mail_Send/sandbox_mode.html).
public struct SandboxMode: MailSetting {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A bool indicating if the setting should be toggle on or off.
    public var enable: Bool
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the setting with a flag indicating if its enabled or not.
    ///
    /// - Parameter enable: A bool indicating if the setting should be toggle on
    ///                     or off (default is `true`).
    public init(enable: Bool = true) {
        self.enable = enable
    }
    
}

/// Encodable conformance
public extension SandboxMode {
    
    public enum CodingKeys: String, CodingKey {
        case sandboxMode = "sandbox_mode"
    }
    
    public enum AdditionalKeys: String, CodingKey {
        case enable
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var additionalInfo = container.nestedContainer(keyedBy: AdditionalKeys.self, forKey: .sandboxMode)
        try additionalInfo.encode(self.enable, forKey: .enable)
    }
    
}
