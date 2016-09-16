//
//  GoogleAnalytics.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `GoogleAnalytics` class is used to toggle the Google Analytics setting, which adds GA parameters to links in the email.
 
 */
open class GoogleAnalytics: Setting, TrackingSetting {

    // MARK: - Properties
    //=========================================================================
    
    /// Name of the referrer source. (e.g. Google, SomeDomain.com, or Marketing Email)
    open let source: String
    
    /// Name of the marketing medium. (e.g. Email)
    open let medium: String
    
    /// Used to identify any paid keywords.
    open let term: String
    
    /// Used to differentiate your campaign from advertisements.
    open let content: String
    
    /// The name of the campaign.
    open let campaign: String
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        let current = [
            "utm_source": self.source,
            "utm_medium": self.medium,
            "utm_term": self.term,
            "utm_content": self.content,
            "utm_campaign": self.campaign
        ]
        for (key, value) in current {
            hash[key] = value
        }
        return [
            "ganalytics": hash
        ]
    }
    
    
    // MARK: - Initializers
    //=========================================================================
    /**
     
     Initializes the setting.
     
     - parameter enable:	A bool indicating whether the setting should be on or off.
     - parameter source:    Name of the referrer source. (e.g. Google, SomeDomain.com, or Marketing Email)
     - parameter medium:    Name of the marketing medium. (e.g. Email)
     - parameter term:      Used to identify any paid keywords.
     - parameter content:   Used to differentiate your campaign from advertisements.
     - parameter campaign:  The name of the campaign.
     
     */
    public init(enable: Bool, source: String, medium: String, term: String, content: String, campaign: String) {
        self.source = source
        self.medium = medium
        self.term = term
        self.content = content
        self.campaign = campaign
        super.init(enable: enable)
    }
    
}
