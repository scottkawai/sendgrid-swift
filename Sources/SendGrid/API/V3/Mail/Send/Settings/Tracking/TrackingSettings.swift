//
//  TrackingSettings.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation


/// The `TrackingSetting` struct houses any tracking settings an email should be
/// configured with.
public struct TrackingSetting: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The BCC setting.
    public var clickTracking: ClickTracking?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with no settings set.
    public init() {}
    
}

/// Encodable conformance.
public extension TrackingSetting {
    
    public enum CodingKeys: String, CodingKey {
        
        case clickTracking  = "click_tracking"
        
    }
    
}
