//
//  Block.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

/// The `Block` struct represents a block event.
public struct Block: EmailEventRepresentable, Codable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The email address on the event.
    public let email: String
    
    /// The date and time the event occurred on.
    public let created: Date
    
    /// The response from the recipient server.
    public let reason: String
    
    /// The status code of the event.
    public let status: String
    
}
