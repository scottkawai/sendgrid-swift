//
//  ClickTracking.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ClickTracking` class is used to adjust the click tracking setting.
 
 */
open class ClickTracking: Setting, TrackingSetting {
    
    // MARK: - Properties
    //=========================================================================
    
    /// A boolean indicating if click tracking should also be applied to links inside a plain text email.
    open let enableText: Bool?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        if let plain = self.enableText {
            hash["enable_text"] = plain
        }
        return [
            "click_tracking": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the setting.
     
     - parameter enable:            A bool indicating if the setting should be on or off.
     - parameter enablePlainText:   A bool indicating if click tracking should be applied to plain text emails or not.
     
     */
    public init(enable: Bool, enablePlainText: Bool? = nil) {
        self.enableText = enablePlainText
        super.init(enable: enable)
    }
    
}
