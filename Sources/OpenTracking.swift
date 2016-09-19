//
//  OpenTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `OpenTracking` class is used to toggle the open tracking setting for an email.
 
 */
open class OpenTracking: Setting, TrackingSetting {

    // MARK: - Properties
    //=========================================================================
    
    /// An optional tag to specify where to place the open tracking pixel.
    open var substitutionTag: String?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        if let sub = self.substitutionTag {
            hash["substitution_tag"] = sub
        }
        return [
            "open_tracking": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the setting.
     
     - parameter enable:            A boolean indicating if the setting should be on or off.
     - parameter substitutionTag:   An optional tag to specify where to place the open tracking pixel.
     
     */
    public init(enable: Bool, substitutionTag: String? = nil) {
        self.substitutionTag = substitutionTag
        super.init(enable: enable)
    }
    
}
