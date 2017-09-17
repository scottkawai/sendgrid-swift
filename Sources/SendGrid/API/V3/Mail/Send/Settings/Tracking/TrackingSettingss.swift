//
//  TrackingSettings.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/16/17.
//

import Foundation


/// The `TrackingSettings` struct houses any tracking settings an email should be
/// configured with.
public struct TrackingSettings: Encodable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The click tracking setting.
    public var clickTracking: ClickTracking?
    
    /// The Google Analytics setting.
    public var googleAnalytics: GoogleAnalytics?
    
    /// The open tracking setting.
    public var openTracking: OpenTracking?
    
    /// The subscription tracking setting.
    public var subscriptionTracking: SubscriptionTracking?
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /// Initializes the struct with no settings set.
    public init() {}
    
}

/// Encodable conformance.
public extension TrackingSettings {
    
    public enum CodingKeys: String, CodingKey {
        
        case clickTracking          = "click_tracking"
        case googleAnalytics        = "ganalytics"
        case openTracking           = "open_tracking"
        case subscriptionTracking   = "subscription_tracking"
        
    }
    
}

/// Validatable conformance.
extension TrackingSettings: Validatable {
    
    /// Bubbles up the `subscriptionTracking` validation.
    public func validate() throws {
        try self.subscriptionTracking?.validate()
    }
    
}
